//
//  LocationClient+Dependency.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import ComposableArchitecture

extension LocationClient: DependencyKey {
    public static var liveValue = LocationClient.live
    public static var previewValue = LocationClient.preview
    public static var testValue = LocationClient.test
}

extension DependencyValues {
    public var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
