//
//  Location.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 02.10.2022.
//

public struct Location: Equatable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
