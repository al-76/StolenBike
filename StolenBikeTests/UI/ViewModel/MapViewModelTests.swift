//
//  MapViewModelTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 04.10.2022.
//

import XCTest

@testable import StolenBike

final class MapViewModelTests: XCTestCase {
    private var getPlaces: UseCaseMock<LocationArea, (Location, [Place])>!
    private var getLocation: UseCaseMock<Void, Location>!
    private var viewModel: MapViewModel!
    private let testData = MapViewModel.Data(location:
                                                Location(latitude: 100.0,
                                                         longitude: 100.0),
                                             places: [
                                                Place(id: 1000,
                                                      location:
                                                        Location(latitude: 200.0,
                                                                 longitude: 200.0))
                                             ])

    override func setUp() {
        super.setUp()

        getPlaces = UseCaseMock<LocationArea, (Location, [Place])>()
        getLocation = UseCaseMock<Void, Location>()
        viewModel = MapViewModel(getLocation: getLocation,
                                 getPlaces: getPlaces)
    }

    func testOnceFetchLocation() throws {
        // Arrange
        let location = testData.location
        let places = testData.places
        let area = LocationArea(location: location, distance: 10.0)
        getPlaces.callAsFunctionHandler = { successAnswer(($0.location, places)) }
        getLocation.callAsFunctionHandler = { _ in successAnswer(location) }

        // Act
        viewModel.onceFetchLocation(at: area)
        try awaitPublisher(viewModel.$state.dropFirst())
        viewModel.onceFetchLocation(at: area)

        // Assert
        XCTAssertEqual(getLocation.callAsFunctionCallCount, 1)
    }

    func testFetchLocation() {
        // Arrange
        let location = testData.location
        let places = testData.places
        let area = LocationArea(location: location, distance: 10.0)
        getPlaces.callAsFunctionHandler = { successAnswer(($0.location, places)) }
        getLocation.callAsFunctionHandler = { _ in successAnswer(location) }

        // Act
        viewModel.fetchLocation(at: area)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(testData))
    }

    func testFetchLocationGetLocationError() {
        // Arrange
        let area = LocationArea(location: testData.location, distance: 10.0)
        getPlaces.callAsFunctionHandler = { _ in noAnswer() }
        getLocation.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.fetchLocation(at: area)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchLocationGetPlacesError() {
        // Arrange
        let location = testData.location
        let area = LocationArea(location: location, distance: 10.0)
        getPlaces.callAsFunctionHandler = { _ in failAnswer() }
        getLocation.callAsFunctionHandler = { _ in successAnswer(location) }

        // Act
        viewModel.fetchLocation(at: area)

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
}
