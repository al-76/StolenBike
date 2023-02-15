//
//  BikeClient+Dependency.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 11.02.2023.
//

import ComposableArchitecture

extension BikeClient: DependencyKey {
    static var liveValue = BikeClient.live
    static var previewValue = BikeClient.preview
    static var testValue = BikeClient.test
}

extension DependencyValues {
    var bikeClient: BikeClient {
        get { self[BikeClient.self] }
        set { self[BikeClient.self] = newValue }
    }
}
