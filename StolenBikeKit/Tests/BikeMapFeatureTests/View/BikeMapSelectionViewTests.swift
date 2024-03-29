//
//  BikeMapSelectionViewTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 02.04.2023.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

import BikeClient
import Utils
import TestUtils

@testable import BikeMapFeature

final class BikeMapSelectionViewTests: XCTestCase {
    override func setUp() {
//        isRecording = true
    }

    func testOneBikeSelected() throws {
        // Arrange
        let view = BikeMapSelectionView(
            store: .init(initialState: .init(bikes: [Bike.stub]),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }

    func testMultipleBikesSelected() throws {
        // Arrange
        let view = BikeMapSelectionView(
            store: .init(initialState: .init(bikes: .stub),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .defaultImage)
    }
}
