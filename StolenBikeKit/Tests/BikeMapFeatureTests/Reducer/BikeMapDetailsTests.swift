//
//  BikeMapDetailsTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 27.03.2023.
//

import ComposableArchitecture
import XCTest

import BikeClient
import Utils
import TestUtils

@testable import BikeMapFeature

@MainActor
final class BikeMapDetailsTests: XCTestCase {
    private var store: TestStore<BikeMapDetails.State,
                                 BikeMapDetails.Action,
                                 BikeMapDetails.State,
                                 BikeMapDetails.Action, ()>!

    override func setUp() {
        store = TestStore(initialState: .init(),
                          reducer: BikeMapDetails())
    }

    func testFetch() async throws {
        // Arrange
        store.dependencies.bikeClient.fetchDetails = { @Sendable _ in .stub }

        // Act
        await store.send(.fetch(100))

        // Assert
        await store.receive(.fetchResult(.success(.stub))) {
            $0.details = .success(.stub)
        }
    }

    func testFetchError() async throws {
        // Arrange
        let error = TestError.someError
        store.dependencies.bikeClient.fetchDetails = { @Sendable _ in throw error }

        // Act
        await store.send(.fetch(100))

        // Assert
        await store.receive(.fetchResult(.failure(error))) {
            $0.details = .failure(StateError(error: error))
        }
    }
}
