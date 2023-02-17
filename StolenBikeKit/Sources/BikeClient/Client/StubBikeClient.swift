//
//  StubPlacesClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 11.02.2023.
//

import XCTestDynamicOverlay

// MARK: - Preview
extension BikeClient {
    static var preview = Self(fetch: { _, _ in .stub })
}

// MARK: - Test
extension BikeClient {
    static var test = Self(fetch: unimplemented("BikeClient.fetch"))
}
