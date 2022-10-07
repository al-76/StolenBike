//
//  DefaultLocationRepository.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 06.10.2022.
//

import Foundation
import Combine

final class DefaultLocationRepository: LocationRepository {
    static let defaultLocation = Location(latitude: 59.3293,
                                          longitude: 18.0686)

    private let locationManager: LocationManager

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }

    func read() -> AnyPublisher<Location, Error> {
        Future { [weak self] promise in
            self?.locationManager.getLocation { result in
                switch result {
                case .success(let location):
                    promise(.success(location))

                case .failure(let error):
                    print("DefaultLocationRepository: \(error)")
                    promise(.success(Self.defaultLocation))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
