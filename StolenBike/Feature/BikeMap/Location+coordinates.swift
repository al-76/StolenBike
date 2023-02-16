//
//  Location+coordinates.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 14.02.2023.
//

import MapKit
import SharedModel

extension Location {
    init(_ location: CLLocationCoordinate2D) {
        self.init(latitude: location.latitude, longitude:
                    location.longitude)
    }

    func coordinates() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude,
                               longitude: longitude)
    }
}
