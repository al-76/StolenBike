//
//  StubPlacesClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 11.02.2023.
//

import XCTestDynamicOverlay

// MARK: - Preview
extension BikeClient {
    static var preview = Self(fetch: { _, _, _ in .stub },
                              fetchDetails: { _ in .stub },
                              pageSize: { .stub })
}

// MARK: - Test
extension BikeClient {
    static var test = Self(fetch: unimplemented("BikeClient.fetch"),
                           fetchDetails: unimplemented("BikeClient.fetchDetails"),
                           pageSize: unimplemented("BikeClient.pageSize"))
}
