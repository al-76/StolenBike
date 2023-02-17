//
//  Bike.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 03.10.2022.
//

import SharedModel

public struct Bike: Identifiable, Equatable {
    public let id: Int
    public let stolenLocation: Location?

    public init(id: Int, stolenLocation: Location?) {
        self.id = id
        self.stolenLocation = stolenLocation
    }
}
