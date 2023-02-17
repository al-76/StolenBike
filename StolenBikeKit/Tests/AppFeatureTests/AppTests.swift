//
//  AppTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import ComposableArchitecture
import XCTest

@testable import AppFeature

@MainActor
final class AppTests: XCTestCase {
    private var store: TestStore<App.State,
                                 App.Action,
                                 App.State,
                                 App.Action, ()>!

    override func setUp() {
        store = TestStore(initialState: .init(),
                          reducer: App())
    }

    func testSelectTab() async throws {
        // Arrange, Act
        await store.send(.selectTab(.registerBike)) {
            // Assert
            $0.tab = .registerBike
        }
    }
}
