//
//  BikeMapListViewTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 20.03.2023.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

import TestUtils

@testable import BikeMapFeature

final class BikeMapListViewTests: XCTestCase {
    override func setUp() {
//        isRecording = true
    }

    func testGeneralFraction() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(bikes: .stub),
                         reducer: EmptyReducer()),
            detendId: .constant(.fraction)
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testGeneralLarge() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(bikes: .stub),
                         reducer: EmptyReducer()),
            detendId: .constant(.large)
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testIsLoadingFraction() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(bikes: .stub,
                                             isLoading: true),
                         reducer: EmptyReducer()),
            detendId: .constant(.fraction)
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testIsLoadingLarge() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(bikes: .stub,
                                             isLoading: true),
                         reducer: EmptyReducer()),
            detendId: .constant(.large)
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testQueryFraction() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(query: "test",
                                             bikes: .stub),
                        reducer: EmptyReducer()),
            detendId: .constant(.fraction)
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testQueryLarge() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(query: "test",
                                             bikes: .stub),
                        reducer: EmptyReducer()),
            detendId: .constant(.large)
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }
}
