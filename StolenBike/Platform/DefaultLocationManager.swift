//
//  LocationManager.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 06.10.2022.
//

import Foundation
import CoreLocation
import Combine

final class DefaultLocationManager: NSObject,
                                     CLLocationManagerDelegate,
                                    LocationManager {
    private enum LocationManagerError: Error {
        case serviceIsNotAvailable
        case noLocation
    }

    private let locationManager = CLLocationManager()
    private var onGetLocation: OnGetLocation?

    override init() {
        super.init()

        locationManager.delegate = self
    }

    func getLocation(onGetLocation: @escaping OnGetLocation) {
        self.onGetLocation = onGetLocation
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }

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
            onGetLocation?(.failure(LocationManagerError.serviceIsNotAvailable))

        default:
            break
        }
    }
}
