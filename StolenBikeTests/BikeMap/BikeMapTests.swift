//
//  BikeMapTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import ComposableArchitecture
import MapKit
import SharedModel
import XCTest

@testable import StolenBike

@MainActor
final class BikeMapTests: XCTestCase {
    private var store: TestStore<BikeMap.State,
                                 BikeMap.Action,
                                 BikeMap.State,
                                 BikeMap.Action, ()>!

    override func setUp() {
        store = TestStore(initialState: .init(),
                          reducer: BikeMap())
    }

    func testUpdateRegion() async {
        // Arrange
        store = TestStore(initialState: .init(area: .stub),
                          reducer: BikeMap())
        let region = MKCoordinateRegion(center: Location.stub.coordinates(),
                                        span: MKCoordinateSpan())

        // Act, Assert
        await store.send(.updateRegion(region)) {
            $0.region = region
        }
    }

    func testUpdateRegionIsOutOfArea() async {
        // Arrange
        store = TestStore(initialState: .init(area: .stub),
                          reducer: BikeMap())
        let region = MKCoordinateRegion()

        // Act, Assert
        await store.send(.updateRegion(region)) {
            $0.region = region
            $0.isOutOfArea = true
        }
    }

    func testUpdateRegionSkipNilRegion() async {
        await store.send(.updateRegion(nil))
    }

    func testUpdateRegionSkipNilArea() async {
        // Arrange
        let region = MKCoordinateRegion()

        // Act, Assert
        await store.send(.updateRegion(region))
    }

    func testGetLocation() async {
        // Arrange
        store.dependencies.locationClient.get = { Answer.streamSuccess([.stub]) }

        // Act
        await store.send(.getLocation)

        // Assert
        await store.receive(.getLocationResult(.success(.stub))) {
            $0.region = MKCoordinateRegion(center: Location.stub.coordinates(),
                                           latitudinalMeters: BikeMap.areaDistance / 2,
                                           longitudinalMeters: BikeMap.areaDistance / 2)
            $0.area = LocationArea(location: .stub,
                                   distance: BikeMap.areaDistance)
        }
    }

    func testGetLocationUpdateRegion() async {
        // Arrange
        let region = MKCoordinateRegion()
        store = TestStore(initialState: .init(region: region),
                          reducer: BikeMap())
        store.dependencies.locationClient.get = { Answer.streamSuccess([.stub]) }

        // Act
        await store.send(.getLocation)

        // Assert
        await store.receive(.getLocationResult(.success(.stub))) {
            $0.region = MKCoordinateRegion(center: Location.stub.coordinates(),
                                           span: region.span)
            $0.area = LocationArea(location: .stub,
                                   distance: BikeMap.areaDistance)
        }
    }

    func testGetLocationError() async {
        // Arrange
        store.dependencies.locationClient.get = { Answer.streamFailure() }

        // Act
        await store.send(.getLocation)

        // Assert
        await store.receive(.getLocationResult(.failure(TestError.someError))) {
            $0.locationError = StateError(error: TestError.someError)
        }
    }

    func testChangeArea() async {
        // Arrange
        let region = MKCoordinateRegion()
        store = TestStore(initialState: .init(region: region),
                          reducer: BikeMap())

        // Act, Assert
        await store.send(.changeArea) {
            $0.area = LocationArea(location: Location(region.center),
                                   distance: BikeMap.areaDistance)
        }
    }

    func testChangeAreaSkipNilRegion() async {
        await store.send(.changeArea)
    }

    func testFetch() async {
        // Arrange
        store = TestStore(initialState: .init(area: .stub),
                          reducer: BikeMap())
        store.dependencies.bikeClient.fetch = { @Sendable _, _ in .stub }

        // Act
        await store.send(.fetch) {
            $0.isOutOfArea = false
            $0.isLoading = true
        }

        // Assert
        await store.receive(.fetchResult(.success(.stub))) {
            $0.bikes = .stub
        }
        await store.receive(.fetchMore) {
            $0.page = 2
        }
    }

    func testFetchEmptyBikes() async {
        // Arrange
        store = TestStore(initialState: .init(area: .stub,
                                              bikes: .stub),
                          reducer: BikeMap())
        store.dependencies.bikeClient.fetch = { @Sendable _, _ in [] }

        // Act
        await store.send(.fetch) {
            $0.isOutOfArea = false
            $0.isLoading = true
        }

        // Assert
        await store.receive(.fetchResult(.success([]))) {
            $0.isLoading = false
            $0.bikes = .stub
        }
    }

    func testFetchMoreSkipMaxPages() async {
        // Arrange
        store = TestStore(initialState: .init(area: .stub,
                                              page: BikeMap.maxPages),
                          reducer: BikeMap())

        // Act, Assert
        await store.send(.fetchMore)
    }

    func testFetchSkipNilArea() async {
        await store.send(.fetch)
    }

    func testFetchError() async {
        // Arrange
        store = TestStore(initialState: .init(area: .stub),
                          reducer: BikeMap())
        store.dependencies.bikeClient.fetch = { @Sendable _, _ in throw TestError.someError }

        // Act
        await store.send(.fetch) {
            $0.isLoading = true
            $0.fetchError = nil
        }

        // Assert
        await store.receive(.fetchResult(.failure(TestError.someError))) {
            $0.isLoading = false
            $0.page = 1
            $0.fetchError = StateError(error: TestError.someError)
        }
    }

    func testFetchMoreError() async {
        // Arrange
        let testPage = 2
        store = TestStore(initialState: .init(area: .stub,
                                              page: testPage),
                          reducer: BikeMap())
        store.dependencies.bikeClient.fetch = { @Sendable _, _ in throw TestError.someError }

        // Act
        await store.send(.fetchMore) {
            $0.isLoading = true
            $0.page = testPage + 1
            $0.fetchError = nil
        }

        // Assert
        await store.receive(.fetchResult(.failure(TestError.someError))) {
            $0.isLoading = false
            $0.page = testPage
            $0.fetchError = StateError(error: TestError.someError)
        }
    }
}
