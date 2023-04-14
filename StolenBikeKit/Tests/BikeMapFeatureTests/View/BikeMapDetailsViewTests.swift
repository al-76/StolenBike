//
//  BikeMapDetailsViewTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 27.03.2023.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

import Utils
import TestUtils

@testable import BikeMapFeature

final class BikeMapDetailsViewTests: XCTestCase {
    private let layout: SwiftUISnapshotLayout = .device(config: .iPhone13Pro)

    override func setUp() {
//        isRecording = true
    }

    func testGeneral() throws {
        // Arrange
        let view = BikeMapDetailsView(
            id: 100,
            store: .init(initialState: .init(details: .success(.stub)),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(perceptualPrecision: 0.98, layout: layout))
    }

    func testLoading() throws {
        // Arrange
        let view = BikeMapDetailsView(
            id: 100,
            store: .init(initialState: .init(details: .loading),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testError() throws {
        // Arrange
        let view = BikeMapDetailsView(
            id: 100,
            store: .init(initialState: .init(
                details: .failure(StateError(error: TestError.someError))
            ),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }
}
