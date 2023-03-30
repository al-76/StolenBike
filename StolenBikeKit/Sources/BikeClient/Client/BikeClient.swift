//
//  BikeClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import SharedModel

public struct BikeClient {
    public enum Stolenness: String {
        case proximity
        case stolen
        case non
        case all
    }

    public var fetch: @Sendable (
        /* area */ LocationArea?,
        /* page */ Int,
        /* query */ String,
        /* stolenness */ Stolenness /*! applicable only if area == nil !*/
    ) async throws -> [Bike]

    public var fetchDetails: @Sendable (
        /* id */ Int
    ) async throws -> BikeDetails

    public var pageSize: () -> Int
}
