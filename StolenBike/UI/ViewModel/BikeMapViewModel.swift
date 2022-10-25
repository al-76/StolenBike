//
//  BikeMapViewModel.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import Foundation
import Combine
import CoreLocation
import MapKit

final class BikeMapViewModel<S: Scheduler>: ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(),
                                               span: MKCoordinateSpan(latitudeDelta: 0.2,
                                                                      longitudeDelta: 0.2))
    @Published var error: Error?
    @Published var places = [Place]()

    private let getLocation: any UseCase<Void, Location>
    private let getPlaces: any UseCase<(LocationArea, Int), [Place]>
    private let debounceScheduler: S

    private var isLocationLoaded = false

    init(getLocation: some UseCase<Void, Location>,
         getPlaces: some UseCase<(LocationArea, Int), [Place]>,
         debounceScheduler: S) {
        self.getLocation = getLocation
        self.getPlaces = getPlaces
        self.debounceScheduler = debounceScheduler

        initBindings()
    }

    private func initBindings() {
        $region
            .dropFirst()
            .filter { [weak self] _ in self?.isLocationLoaded ?? false }
            .debounce(for: .seconds(0.5),
                      scheduler: debounceScheduler)
            .map { [weak self] region in
                guard let self else {
                    return Just([Place]())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.getPlaces((region.area(), 1))
            }
            .switchToLatest()
            .catch { [weak self] error in
                self?.publish(error: error)
                return Just([Place]()).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$places)

        $places
            .dropFirst()
            .filter { $0.count < 500 }
            .map { [weak self] places in
                guard let self else {
                    return Just(places)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.getPlaces((self.region.area(), 1 + places.count))
            }
            .switchToLatest()
            .filter { !$0.isEmpty }
            .map { [weak self] newPlaces in
                (self?.places ?? []) + newPlaces
            }
            .catch { [weak self] error in
                self?.publish(error: error)
                return Just(self?.places ?? []).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$places)
    }

    func fetchLocation() {
        let region = self.region
        getLocation()
            .map {
                region.update(center: $0.coordinates())
            }
            .catch { [weak self] error in
                self?.publish(error: error)
                return Just(region).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLocationLoaded = true
            })
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
