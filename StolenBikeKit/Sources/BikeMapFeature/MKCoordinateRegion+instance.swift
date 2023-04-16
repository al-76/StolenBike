//
//  MKCoordinateRegion+instance.swift
//  
//
//  Created by Vyacheslav Konopkin on 08.04.2023.
//

import MapKit

extension MKCoordinateRegion {
    public static let distant = MKCoordinateRegion(
        center: CLLocationCoordinate2D(),
        latitudinalMeters: 700 * BikeMap.areaDistance,
        longitudinalMeters: 700 * BikeMap.areaDistance
    )

    public static let near = MKCoordinateRegion(
        center: CLLocationCoordinate2D(),
        latitudinalMeters: BikeMap.areaDistance,
        longitudinalMeters: BikeMap.areaDistance
    )
}

extension MKCoordinateSpan {
    public static let distant = MKCoordinateRegion.distant.span
    public static let near = MKCoordinateRegion.near.span
}
