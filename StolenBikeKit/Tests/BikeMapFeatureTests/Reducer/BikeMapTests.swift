//
//  BikeMapTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import ComposableArchitecture
import MapKit
import XCTest

import BikeClient
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

    func testLoad() async throws {
        // Arrange
        let saveData = BikeMap.SaveData(region: MKCoordinateRegion(),
                                        area: .stub)
        let data = try JSONEncoder().encode(saveData)
        store.exhaustivity = .off
        store.dependencies.userDefaultsClient.data = { _ in data }
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.load)

        // Assert
        await store.receive(.loadResult(.success(saveData))) {
            $0.region = saveData.region
            $0.area = saveData.area
        }
        await store.receive(.list(.fetch))
    }

    func testLoadNoData() async throws {
        // Arrange
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }
        store.dependencies.userDefaultsClient.data = { _ in nil }
        store.dependencies.userDefaultsClient.setData = { @Sendable _, _ in }
        store.dependencies.locationClient.get = { .stub }

        // Act
        await store.send(.load) {
            $0.isSupressedLocationError = true
        }

        // Assert
        await store.receive(.getLocationResult(.success(.stub)))
    }

    func testSave() async {
        // Arrange
        store.dependencies.userDefaultsClient.setData = { @Sendable _, _ in }

        // Act, Assert
        await store.send(.save)
    }

    func testUpdateRegion() async {
        // Arrange
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

    func testUpdateRegionSkipNilArea() async {
        // Arrange
        let region = MKCoordinateRegion()
        store = TestStore(initialState: .init(region: region),
                          reducer: BikeMap())

        // Act, Assert
        await store.send(.updateRegion(region))
    }

    func testGetLocation() async {
        // Arrange
        store = TestStore(initialState: .init(area: nil),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.locationClient.get = { .stub }
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }
        store.dependencies.userDefaultsClient.setData = { @Sendable _, _ in }

        // Act
        await store.send(.getLocation) {
            $0.isLoading = true
        }

        // Assert
        await store.receive(.getLocationResult(.success(.stub))) {
            $0.region.center = Location.stub.coordinates()
            $0.area = LocationArea(location: .stub,
                                   distance: BikeMap.areaDistance)
        }
        await store.receive(.list(.fetch))
    }

    func testGetLocationError() async {
        // Arrange
        let error = TestError.someError
        store.exhaustivity = .off
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

    func testGetLocationErrorSupressed() async {
        // Arrange
        let error = TestError.someError
        store = TestStore(initialState: .init(isSupressedLocationError: true),
                          reducer: BikeMap())
        store.exhaustivity = .off
        store.dependencies.locationClient.get = { throw error }

        // Act
        await store.send(.getLocation)

        // Assert
        await store.receive(.getLocationResult(.failure(error))) {
            $0.locationError = nil
        }
    }

    func testOpenSettings() async {
        // Arrange
        store.dependencies.settingsClient.open = { }

        // Act
        await store.send(.openSettings)

        // Assert
        await store.receive(.openSettingsResult(.success(true)))
    }

    func testOpenSettingsError() async {
        // Arrange
        let error = TestError.someError
        store.dependencies.settingsClient.open = { throw error }

        // Act
        await store.send(.openSettings)

        // Assert
        await store.receive(.openSettingsResult(.failure(error))) {
            $0.settingsError = StateError(error: error)
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
        store.dependencies.userDefaultsClient.setData = { @Sendable _, _ in }

        // Act
        await store.send(.changeArea) {
            $0.area = LocationArea(location: Location(region.center),
                                   distance: BikeMap.areaDistance)
        }

        // Assert
        await store.receive(.list(.fetch))
    }

    func testFetch() async {
        // Arrange
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
        store.exhaustivity = .off
        store.dependencies.locationClient.get = { .stub }
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }
        store.dependencies.userDefaultsClient.setData = { @Sendable _, _ in }

        // Act
        await store.send(.list(.updateSearchMode(.localStolen)))

        // Assert
        await store.receive(.getLocationResult(.success(.stub)))
    }

    func testListUpdateSearchModeIsGlobal() async {
        // Arrange
        store.exhaustivity = .off
        store.dependencies.bikeClient.fetch = { @Sendable _, _, _, _ in .stub }
        store.dependencies.bikeClient.pageSize = { .stub }

        // Act
        await store.send(.list(.updateSearchMode(.all))) {
            $0.area = nil
        }

        // Assert
        await store.receive(.list(.fetch))
    }

    func testSelectBikesIds() async {
        // Arrange
        store = TestStore(initialState: .init(
            list: .init(bikes: .stub)
        ),
                          reducer: BikeMap())
        let bikeIds = [Bike].stub.map(\.id)

        // Act, Assert
        await store.send(.select(bikeIds)) {
            $0.selection.bikes = .stub
        }
    }

    func testFetchErrorCancel() async {
        // Arrange
        store = TestStore(initialState: .init(
            fetchError: StateError(error: TestError.someError)
        ),
                          reducer: BikeMap())

        // Act, Assert
        await store.send(.fetchErrorCancel) {
            $0.fetchError = nil
        }
    }

    func testLocationErrorCancel() async {
        // Arrange
        store = TestStore(initialState: .init(
            locationError: StateError(error: TestError.someError)
        ),
                          reducer: BikeMap())

        // Act, Assert
        await store.send(.locationErrorCancel) {
            $0.locationError = nil
        }
    }

    func testSettingsErrorCancel() async {
        // Arrange
        store = TestStore(initialState: .init(
            settingsError: StateError(error: TestError.someError)
        ),
                          reducer: BikeMap())

        // Act, Assert
        await store.send(.settingsErrorCancel) {
            $0.settingsError = nil
        }
    }
}
