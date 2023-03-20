//
//  LocationClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import SharedModel

public struct LocationClient {
    public var get: () async throws -> Location
}
