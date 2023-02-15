//
//  LocationClient+Dependency.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import ComposableArchitecture

extension LocationClient: DependencyKey {
    static var liveValue = LocationClient.live
    static var previewValue = LocationClient.preview
    static var testValue = LocationClient.test
}

extension DependencyValues {
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
