//
//  AppViewTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 21.02.2023.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

@testable import AppFeature

final class AppViewTests: XCTestCase {
    private let layout: SwiftUISnapshotLayout = .device(config: .iPhone13Pro)

    func testBikeMap() {
        // Arrange
        let view = AppView(
            store: .init(initialState: .init(tab: .bikeMap),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testRegisterBike() {
        // Arrange
        let view = AppView(
            store: .init(initialState: .init(tab: .registerBike),
                         reducer: EmptyReducer())
        )

        // Assert
        assertSnapshot(matching: view, as: .image(layout: layout))
    }
}
