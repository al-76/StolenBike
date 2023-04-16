//
//  BikeMapViewSnapshotTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 22.02.2023.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

import LocationClient
import TestUtils

@testable import BikeMapFeature

final class BikeMapViewTests: XCTestCase {
    override func setUp() {
//        isRecording = true
    }

    func testGeneral() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(area: .stub),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testIsLoading() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(area: .stub, isLoading: true),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testIsOutOfArea() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(area: .stub, isOutOfArea: true),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testAreaNotSelected() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testLocationError() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(
                locationError: .init(error: TestError.someError)
            ), reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testLocationErrorServiceIsNotAvailable() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(
                locationError: .init(error: LocationManagerError.serviceIsNotAvailable)
            ), reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testFetchError() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(
                fetchError: .init(error: TestError.someError)
            ), reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }
}
