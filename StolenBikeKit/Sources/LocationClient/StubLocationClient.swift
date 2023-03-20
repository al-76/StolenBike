//
//  StubLocationClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import XCTestDynamicOverlay

// MARK: - Preview
extension LocationClient {
    static var preview = Self(get: { .stub })
}

// MARK: - Test
extension LocationClient {
    static var test = Self(get: unimplemented("LocationClient.get"))
}
