//
//  LocationClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import SharedModel

struct LocationClient {
    var get: () -> AsyncThrowingStream<Location, Error>
}
