//
//  LocationArea.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 08.10.2022.
//

public struct LocationArea: Equatable {
    public let location: Location
    public let distance: Double // meters

    public init(location: Location, distance: Double) {
        self.location = location
        self.distance = distance
    }
}
