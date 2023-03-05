//
//  BikeMapSettingsViewTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 06.03.2023.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

import TestUtils

@testable import BikeMapFeature

final class BikeMapSettingsViewTests: XCTestCase {
    private let layout: SwiftUISnapshotLayout = .device(config: .iPhone13Pro)

    override func setUp() {
//        isRecording = true
    }

    func testGeneral() throws {
        // Arrange
        let view = BikeMapSettingsView(
            store: .init(initialState: .init(),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testIsGlobalSearch() throws {
        // Arrange
        let view = BikeMapSettingsView(
            store: .init(initialState: .init(isGlobalSearch: true),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }
}
