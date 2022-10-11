//
//  MapViewModel.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import Foundation
import Combine

final class MapViewModel: ObservableObject {
    typealias State = ViewModelState<Data>

    struct Data: Equatable {
        let location: Location
        let places: [Place]
    }

    @Published var state = State.loading

    private let getLocation: any UseCase<Void, Location>
    private let getPlaces: any UseCase<LocationArea, (Location, [Place])>

    init(getLocation: some UseCase<Void, Location>,
         getPlaces: some UseCase<LocationArea, (Location, [Place])>) {
        self.getLocation = getLocation
        self.getPlaces = getPlaces
    }

    func onceFetchLocation(at area: LocationArea) {
        switch state {
        case .loading:
            fetchLocation(at: area)

        default:
            break
        }
    }

    func fetchLocation(at area: LocationArea) {
        getLocation()
            .flatMap { [weak self] location in
                guard let self else {
                    return Just((location, [Place]()))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.getPlaces(LocationArea(location: location,
                                                   distance: area.distance))
            }
            .map { .success(Data(location: $0.0, places: $0.1)) }
            .catch { Just(.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }

    func updatePlaces(at area: LocationArea) {
//        getPlaces(area)
//            .map { .success(Data(location: $0.0, places: $0.1)) }
//            .catch { Just(.failure($0)).eraseToAnyPublisher() }
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$state)
    }
}
