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
        let locationManager = LocationManager()
        return Self(
            get: {
                try await withCheckedThrowingContinuation { continuation in
                    locationManager.getLocation {
                        continuation.resume(with: $0)
                    }
                }
            }
        )
    }
}

private enum LocationManagerError: Error {
    case serviceIsNotAvailable
    case noLocation
}

private final class LocationManager: NSObject {
    typealias OnGetLocation = (Result<Location, Error>) -> Void

    private let locationManager = CLLocationManager()
    private var onGetLocation: OnGetLocation?

    func getLocation(onGetLocation: @escaping OnGetLocation) {
        self.onGetLocation = onGetLocation
        requestLocation()
    }

    private func requestLocation() {
        locationManager.delegate = self
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        stop(manager)

        guard let location = locations.last else {
            onGetLocation?(.failure(LocationManagerError.noLocation))
            return
        }

        onGetLocation?(.success(Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )))
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        stop(manager)
        onGetLocation?(.failure(error))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()

        case .restricted, .denied:
            stop(manager)
            onGetLocation?(.failure(LocationManagerError.serviceIsNotAvailable))

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        default:
            break
        }
    }

    private func stop(_ manager: CLLocationManager) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
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
