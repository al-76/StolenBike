//
//  BikeMapTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import ComposableArchitecture
import MapKit
import XCTest

import SharedModel
import Utils
import TestUtils

@testable import BikeMapFeature

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
        store.exhaustivity = .off

        // Act, Assert
        await store.send(.updateRegion(MKCoordinateRegion())) {
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
        store.exhaustivity = .off
        store.dependencies.locationClient.get = { .stub }
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.getLocation) {
            $0.isLoading = true
        }

        // Assert
        await store.receive(.getLocationResult(.success(.stub))) {
            $0.isLoading = false
            $0.region = MKCoordinateRegion(center: Location.stub.coordinates(),
                                           latitudinalMeters: BikeMap.areaDistance / 2,
                                           longitudinalMeters: BikeMap.areaDistance / 2)
            $0.area = LocationArea(location: .stub,
                                   distance: BikeMap.areaDistance)
        }
        await store.receive(.fetch)
    }

    func testGetLocationUpdateRegion() async {
        // Arrange
        let region = MKCoordinateRegion()
        store = TestStore(initialState: .init(region: region),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.locationClient.get = { .stub }
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.getLocation) {
            $0.isLoading = true
        }

        // Assert
        await store.receive(.getLocationResult(.success(.stub))) {
            $0.isLoading = false
            $0.region = MKCoordinateRegion(center: Location.stub.coordinates(),
                                           span: region.span)
            $0.area = LocationArea(location: .stub,
                                   distance: BikeMap.areaDistance)
        }
        await store.receive(.fetch)
    }

    func testGetLocationSkipSameArea() async {
        // Arrange
        let region = MKCoordinateRegion()
        store = TestStore(initialState: .init(
            region: region,
            area: .stub
        ),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.locationClient.get = { .stub }

        // Act
        await store.send(.getLocation)

        // Assert
        await store.receive(.getLocationResult(.success(.stub))) {
            $0.region = MKCoordinateRegion(center: Location.stub.coordinates(),
                                           span: region.span)
        }
    }

    func testGetLocationError() async {
        // Arrange
        let error = TestError.someError
        store.dependencies.locationClient.get = { throw error }

        // Act
        await store.send(.getLocation) {
            $0.isLoading = true
        }

        // Assert
        await store.receive(.getLocationResult(.failure(error))) {
            $0.isLoading = false
            $0.locationError = StateError(error: error)
        }
    }

    func testChangeArea() async {
        // Arrange
        let region = MKCoordinateRegion()
        store = TestStore(initialState: .init(region: region),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.changeArea) {
            $0.area = LocationArea(location: Location(region.center),
                                   distance: BikeMap.areaDistance)
        }

        // Assert
        await store.receive(.fetch)
    }

    func testChangeAreaSkipNilRegion() async {
        await store.send(.changeArea)
    }

    func testFetch() async {
        // Arrange
        store = TestStore(initialState: .init(area: .stub),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.fetch) {
            $0.isOutOfArea = false
            $0.isLoading = true
        }

        // Assert
        await store.receive(.list(.fetchResult(.success(.stub)))) {
            $0.isLoading = false
            $0.bikes = .stub
        }
    }

    func testFetchError() async {
        // Arrange
        let error = TestError.someError
        store = TestStore(initialState: .init(area: .stub),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in throw error }

        // Act
        await store.send(.fetch) {
            $0.isLoading = true
        }

        // Assert
        await store.receive(.list(.fetchResult(.failure(error)))) {
            $0.isLoading = false
            $0.fetchError = StateError(error: error)
        }
    }

    func testListUpdateSearchModeIsLocal() async {
        // Arrange
        store = TestStore(initialState: .init(),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.locationClient.get = { .stub }

        // Act
        await store.send(.list(.updateSearchMode(.localStolen)))

        // Assert
        await store.receive(.getLocation)
    }

    func testListUpdateSearchModeIsGlobal() async {
        // Arrange
        store = TestStore(initialState: .init(
            list: .init(area: .stub)
        ),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.list(.updateSearchMode(.all))) {
            $0.area = nil
        }

        // Assert
        await store.receive(.fetch)
    }
}
