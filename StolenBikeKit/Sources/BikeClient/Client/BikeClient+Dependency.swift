//
//  BikeClient+Dependency.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 11.02.2023.
//

import ComposableArchitecture

extension BikeClient: DependencyKey {
    public static var liveValue = BikeClient.live
    public static var previewValue = BikeClient.preview
    public static var testValue = BikeClient.test
}

extension DependencyValues {
    public var bikeClient: BikeClient {
        get { self[BikeClient.self] }
        set { self[BikeClient.self] = newValue }
    }
}
