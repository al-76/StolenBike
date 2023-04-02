//
//  BikeMapSelectionTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 02.04.2023.
//

import ComposableArchitecture
import XCTest

import BikeClient
import Utils
import TestUtils

@testable import BikeMapFeature

@MainActor
final class BikeMapSelectionTests: XCTestCase {
    func testUpdateFilter() async throws {
        // Arrange
        let store = TestStore(initialState: .init(),
                              reducer: BikeMapSelection())
        let filter = "test"

        // Act, Assert
        await store.send(.updateFilter(filter)) {
            $0.filter = filter
        }
    }

    func testFilter() async throws {
        // Arrange
        let firstBike = [Bike].stub[0]
        let store = TestStore(initialState: .init(
            bikes: .stub,
            filter: firstBike.title
        ),
                              reducer: BikeMapSelection())

        // Act, Assert
        XCTAssertEqual(store.state.filteredBikes, [firstBike])
    }

    func testEmptyFilter() async throws {
        // Arrange
        let store = TestStore(initialState: .init(
            bikes: .stub,
            filter: ""
        ),
                              reducer: BikeMapSelection())

        // Act, Assert
        XCTAssertEqual(store.state.filteredBikes, .stub)
    }
}
