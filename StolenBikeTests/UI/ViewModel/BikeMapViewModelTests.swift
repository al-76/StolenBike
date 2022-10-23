//
//  BikeMapViewModelTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 04.10.2022.
//

import XCTest
import Combine
import MapKit

@testable import StolenBike

final class BikeMapViewModelTests: XCTestCase {
    private var getPlaces: UseCaseMock<LocationArea, (Location, [Place])>!
    private var getLocation: UseCaseMock<Void, Location>!
    private var viewModel: BikeMapViewModel<ImmediateScheduler>!
    private let testRegion = MKCoordinateRegion()
    private let testLocation = Location(latitude: 100.0,
                                        longitude: 100.0)
    private let testPlaces = [ Place(id: 1,
                                     location: Location(latitude: 200, longitude: 200)),
                               Place(id: 2,
                                     location: Location(latitude: 300, longitude: 300)) ]

    override func setUp() {
        super.setUp()

        getPlaces = UseCaseMock<LocationArea, (Location, [Place])>()
        getPlaces.callAsFunctionHandler = { _ in noAnswer() }
        getLocation = UseCaseMock<Void, Location>()
        viewModel = BikeMapViewModel(getLocation: getLocation,
                                 getPlaces: getPlaces,
                                 debounceScheduler: ImmediateScheduler.shared)
    }

    func testFetchLocation() throws {
        // Arrange
        getLocation.callAsFunctionHandler = { _ in successAnswer(self.testLocation) }

        // Act
        viewModel.fetchLocation()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$region.dropFirst())
            .area().location, testLocation)
    }

    func testFetchLocationError() throws {
        // Arrange
        getLocation.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.fetchLocation()

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$error) as? TestError,
                       TestError.someError)
    }

    func testFetchPlaces() throws {
        // Arrange
        getPlaces.callAsFunctionHandler = { _ in successAnswer((self.testLocation,
                                                                self.testPlaces)) }

        // Act
        viewModel.region = testRegion

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$places.dropFirst()),
                       testPlaces)
    }

    func testFetchPlacesError() throws {
        // Arrange
        getPlaces.callAsFunctionHandler = { _ in failAnswer() }

        // Act
        viewModel.region = testRegion

        // Assert
        XCTAssertEqual(try awaitPublisher(viewModel.$error) as? TestError,
                       TestError.someError)
    }
}
