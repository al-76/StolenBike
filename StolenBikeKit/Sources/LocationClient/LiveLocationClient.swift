//
//  LiveLocationClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import CoreLocation

import SharedModel

public enum LocationManagerError: Error {
    case serviceIsNotAvailable
    case noLocation
}

extension LocationManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serviceIsNotAvailable:
            return NSLocalizedString("Service is not available. Please, change your location settings.", comment: "")

        case .noLocation:
            return NSLocalizedString("No location", comment: "")
        }
    }
}

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

private final class LocationManager: NSObject {
    typealias OnGetLocation = (Result<Location, Error>) -> Void

    private let locationManager = CLLocationManager()
    private var onGetLocation: OnGetLocation?
    private var isHandledResult = false

    func getLocation(onGetLocation: @escaping OnGetLocation) {
        isHandledResult = false
        self.onGetLocation = onGetLocation
        requestLocation()
    }

    private func requestLocation() {
        locationManager.delegate = self
        handleAuthorizationStatus(locationManager)
    }

    private func handleAuthorizationStatus(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()

        case .restricted, .denied:
            handle(result: .failure(LocationManagerError.serviceIsNotAvailable))

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        default:
            break
        }
    }

    private func handle(result: Result<Location, Error>) {
        guard !isHandledResult else { return }

        isHandledResult = true
        locationManager.stopUpdatingLocation()
        onGetLocation?(result)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            handle(result: .failure(LocationManagerError.noLocation))
            return
        }

        handle(result: .success(Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )))
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        handle(result: .failure(error))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(manager)
    }
}
