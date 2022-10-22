//
//  MapViewModel.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import Foundation
import Combine
import CoreLocation
import MapKit

final class MapViewModel<S: Scheduler>: ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(),
                                               span: MKCoordinateSpan(latitudeDelta: 0.2,
                                                                      longitudeDelta: 0.2))
    @Published var error: Error?
    @Published var places = [Place]()

    private let getLocation: any UseCase<Void, Location>
    private let getPlaces: any UseCase<LocationArea, (Location, [Place])>
    private let debounceScheduler: S

    init(getLocation: some UseCase<Void, Location>,
         getPlaces: some UseCase<LocationArea, (Location, [Place])>,
         debounceScheduler: S) {
        self.getLocation = getLocation
        self.getPlaces = getPlaces
        self.debounceScheduler = debounceScheduler

        initBindings()
    }

    private func initBindings() {
        $region
            .debounce(for: .seconds(2),
                      scheduler: debounceScheduler)
            .flatMap { [weak self] value in
                guard let self else {
                    return Just((value.area().location, [Place]()))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.getPlaces(value.area())
            }
            .map { $0.1 }
            .catch { [weak self] error in
                self?.publish(error: error)
                return Just([Place]()).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$places)
    }

    func fetchLocation() {
        let region = self.region
        getLocation()
            .map { region.update(center: $0.coordinates()) }
            .catch { [weak self] error in
                self?.publish(error: error)
                return Just(region).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$region)
    }

    private func publish(error: Error) {
        self.error = error
    }
}

extension MKCoordinateRegion {
    func area() -> LocationArea {
        let location1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5,
                                   longitude: center.longitude)
        let location2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5,
                                   longitude: center.longitude)
        let distance = location1.distance(from: location2)
        return LocationArea(location: Location(latitude: center.latitude,
                                               longitude: center.longitude),
                            distance: distance)
    }
}

extension MKCoordinateRegion {
    func update(center: CLLocationCoordinate2D) -> MKCoordinateRegion {
        var region = self
        region.center = center
        return region
    }
}
