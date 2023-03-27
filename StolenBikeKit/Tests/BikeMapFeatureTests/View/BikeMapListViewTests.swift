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
    private let layout: SwiftUISnapshotLayout = .device(config: .iPhone13Pro)

    override func setUp() {
//        isRecording = true
    }

    func testGeneral() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(bikes: .stub),
                        reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testIsLoading() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(bikes: .stub,
                                             isLoading: true),
                        reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testQuery() throws {
        // Arrange
        let view = BikeMapListView(
            store: .init(initialState: .init(query: "test",
                                             bikes: .stub),
                        reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }
}
