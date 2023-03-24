//
//  BikeClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import SharedModel

public struct BikeClient {
    public var fetch: @Sendable (
        /* area */ LocationArea?,
        /* page */ Int,
        /* query */ String
    ) async throws -> [Bike]

    public var fetchDetails: @Sendable (
        /* id */ Int
    ) async throws -> BikeDetails

    public var pageSize: () -> Int
}
