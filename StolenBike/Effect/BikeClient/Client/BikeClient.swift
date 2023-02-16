//
//  BikeClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import SharedModel

struct BikeClient {
    var fetch: @Sendable (
        /* area */ LocationArea,
        /* page */ Int
    ) async throws -> [Bike]
}
