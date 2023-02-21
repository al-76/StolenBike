//
//  LiveLocationClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import CoreLocation

import SharedModel

extension LocationClient {
    static var live = Self(get: {
        AsyncThrowingStream { continuation in
            Task {
                await MainActor.run {
                    let locationManager = LocationManager() {
                        continuation.yield(with: $0)
                    }
                    continuation.onTermination = { @Sendable _ in
                        locationManager.stop()
                    }
                    locationManager.start()
                }
            }
        }
    })
}

private enum LocationManagerError: Error {
    case serviceIsNotAvailable
    case noLocation
}

private final class LocationManager: NSObject {
    typealias OnGetLocation = (Result<Location, Error>) -> Void

    private let locationManager = CLLocationManager()
    private let onGetLocation: OnGetLocation

    init(onGetLocation: @escaping OnGetLocation) {
        self.onGetLocation = onGetLocation
        super.init()

        locationManager.delegate = self
    }

    func start() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            onGetLocation(.failure(LocationManagerError.noLocation))
            return
        }

        onGetLocation(.success(Location(latitude:
                                            location.coordinate.latitude,
                                         longitude:
                                            location.coordinate.longitude)))
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        onGetLocation(.failure(error))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()

        case .restricted, .denied:
            print(manager.authorizationStatus.customDumpDescription)
            onGetLocation(.failure(LocationManagerError.serviceIsNotAvailable))

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        default:
            break
        }
    }
}

extension LocationManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serviceIsNotAvailable:
            return NSLocalizedString("Service is not available", comment: "Did you deny getting a location?")

        case .noLocation:
            return NSLocalizedString("No location", comment: "")
        }
    }
}
