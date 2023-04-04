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
    private let layout: SwiftUISnapshotLayout = .device(config: .iPhone13Pro)

    override func setUp() {
//        isRecording = true
    }

    func testGeneral() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testIsLoading() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(isLoading: true),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testIsOutOfArea() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(isOutOfArea: true),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testLocationError() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(
                locationError: .init(error: TestError.someError)
            ), reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testLocationErrorServiceIsNotAvailable() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(
                locationError: .init(error: LocationManagerError.serviceIsNotAvailable)
            ), reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testFetchError() throws {
        // Arrange
        let view = BikeMapView(
            store: .init(initialState: .init(
                fetchError: .init(error: TestError.someError)
            ), reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }
}
