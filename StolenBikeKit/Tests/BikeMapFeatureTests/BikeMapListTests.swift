//
//  BikeMapListTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 20.03.2023.
//

import ComposableArchitecture
import XCTest

import BikeClient
import Utils
import TestUtils

@testable import BikeMapFeature

@MainActor
final class BikeMapListTests: XCTestCase {
    private var store: TestStore<BikeMapList.State,
                                 BikeMapList.Action,
                                 BikeMapList.State,
                                 BikeMapList.Action, ()>!

    override func setUp() {
        store = TestStore(initialState: .init(),
                          reducer: BikeMapList())
    }

    func testUpdateQuery() async throws {
        // Arrange
        let query = "test"

        // Act, Assert
        await store.send(.updateQuery(query)) {
            $0.query = query
        }
    }

    func testUpdateQueryDebouncedSkipFirst() async throws {
        await store.send(.updateQueryDebounced)
    }

    func testUpdateQueryDebounced() async throws {
        // Arrange
        store = TestStore(initialState: .init(query: "test"),
                          reducer: BikeMapList())
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.updateQueryDebounced)

        // Assert
        await store.receive(.fetch)
    }

    func testFetch() async throws {
        // Arrange
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.fetch) {
            $0.isLoading = true
        }

        // Assert
        await store.receive(.fetchResult(.success(.stub))) {
            $0.isLoading = false
            $0.bikes = .stub
            $0.isLastPage = true
        }
    }

    func testFetchIsNotLastPage() async throws {
        // Arrange
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { [Bike].stub.count }

        // Act
        await store.send(.fetch)

        // Assert
        await store.receive(.fetchResult(.success(.stub))) {
            $0.isLastPage = false
        }
    }

    func testFetchMore() async throws {
        // Arrange
        let bikes: [Bike] = .stub
        let firstPart = Array(bikes[...(bikes.count / 2)])
        let secondPart = Array(bikes[(bikes.count / 2)...])
        store = TestStore(initialState: .init(bikes: firstPart),
                          reducer: BikeMapList())
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _ in secondPart }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.fetchMore(firstPart.last!)) {
            $0.page = 2
            $0.isLoading = true
        }

        // Assert
        await store.receive(.fetchResult(.success(secondPart))) {
            $0.isLoading = false
            $0.bikes = firstPart + secondPart
            $0.isLastPage = true
        }
    }

    func testFetchError() async throws {
        // Arrange
        let error = TestError.someError
        let bikes: [Bike] = .stub
        store = TestStore(initialState: .init(bikes: bikes),
                          reducer: BikeMapList())
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _ in throw error }

        // Act
        await store.send(.fetchMore(bikes.last!)) {
            $0.isLoading = true
        }

        // Assert
        await store.receive(.fetchResult(.failure(error))) {
            $0.error = StateError(error: error)
            $0.isLoading = false
        }
    }

    func testFetchMoreSkipIsLoading() async throws {
        // Arrange
        let bikes: [Bike] = .stub
        store = TestStore(initialState: .init(bikes: bikes,
                                              isLoading: true),
                          reducer: BikeMapList())

        // Act, Assert
        await store.send(.fetchMore(bikes.last!))
    }

    func testFetchMoreSkipNotLastItem() async throws {
        await store.send(.fetchMore(.stub))
    }

    func testFetchMoreSkipNotLastPage() async throws {
        // Arrange
        let bikes: [Bike] = .stub
        store = TestStore(initialState: .init(bikes: bikes,
                                              isLastPage: true),
                          reducer: BikeMapList())

        // Act, Assert
        await store.send(.fetchMore(bikes.last!))
    }
}
