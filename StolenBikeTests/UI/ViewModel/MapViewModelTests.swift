//
//  MapViewModelTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 04.10.2022.
//

import XCTest

@testable import StolenBike

final class MapViewModelTests: XCTestCase {
    private var getPlaces: UseCaseMock<Location, (Location, [Place])>!
    private var getLocation: UseCaseMock<Void, Location>!
    private var viewModel: MapViewModel!
    private let testData = MapViewModel.Data(location:
                                                Location(latitude: 100.0,
                                                         longitude: 100.0),
                                             places: [
                                                Place(id: UUID(),
                                                      location:
                                                        Location(latitude: 200.0,
                                                                 longitude: 200.0))
                                             ])

    override func setUp() {
        super.setUp()

        getPlaces = UseCaseMock<Location, (Location, [Place])>()
        getLocation = UseCaseMock<Void, Location>()
        viewModel = MapViewModel(getLocation: getLocation,
                                 getPlaces: getPlaces)
    }

    func testFetchLocation() {
        // Arrange
        let location = testData.location
        let places = testData.places
        getPlaces.callAsFunctionHandler = { successAnswer(($0, places)) }
        getLocation.callAsFunctionHandler = { _ in successAnswer(location) }

        // Act
        viewModel.fetchLocation()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .success(testData))
    }

    func testFetchLocationGetLocationError() {
        // Arrange
        getPlaces.callAsFunctionHandler = { _ in noAnswer() }
        getLocation.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.fetchLocation()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }

    func testFetchLocationGetPlacesError() {
        // Arrange
        let location = testData.location
        getPlaces.callAsFunctionHandler = { _ in failAnswer() }
        getLocation.callAsFunctionHandler = { _ in successAnswer(location) }

        // Act
        viewModel.fetchLocation()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$state.dropFirst()),
                       .failure(TestError.someError))
    }
}
