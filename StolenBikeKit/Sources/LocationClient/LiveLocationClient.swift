//
//  LiveLocationClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import CoreLocation

import SharedModel

extension LocationClient {
    static var live: Self {
        return Self(get: {
            return AsyncThrowingStream { continuation in
                let locationManager = LocationManager()
                locationManager.onGetLocation = {
                    continuation.yield(with: $0)
                }
                continuation.onTermination = { @Sendable _ in
                    locationManager.stop()
                }
                locationManager.start()
            }
        })
    }
}

private final class LocationManager: NSObject {
    typealias OnGetLocation = (Result<Location, Error>) -> Void

    enum LocationManagerError: Error {
        case serviceIsNotAvailable
        case noLocation
    }

    private let locationManager = CLLocationManager()

    var onGetLocation: OnGetLocation?

    func start() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            onGetLocation?(.failure(LocationManagerError.noLocation))
            return
        }

        onGetLocation?(.success(Location(latitude:
                                            location.coordinate.latitude,
                                         longitude:
                                            location.coordinate.longitude)))
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        onGetLocation?(.failure(error))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()

        case .restricted, .denied:
            print(manager.authorizationStatus.customDumpDescription)
            onGetLocation?(.failure(LocationManagerError.serviceIsNotAvailable))

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        default:
            break
        }
    }
}

extension LocationManager.LocationManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serviceIsNotAvailable:
            return NSLocalizedString("Service is not available", comment: "Did you deny getting a location?")

        case .noLocation:
            return NSLocalizedString("No location", comment: "")
        }
    }
}
