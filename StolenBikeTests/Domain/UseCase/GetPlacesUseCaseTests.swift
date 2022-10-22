//
//  GetPlacesUseCaseTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 11.10.2022.
//

import XCTest

@testable import StolenBike

final class GetPlacesUseCaseTests: XCTestCase {
    private var repository: PlacesRepositoryMock!
    private var getPlaces: GetPlacesUseCase!
    private let testLocation = Location(latitude: 200.0, longitude: 200.0)

    override func setUp() {
        super.setUp()

        repository = PlacesRepositoryMock()
        getPlaces = GetPlacesUseCase(repository: repository)
    }

    func testExecute() throws {
        // Arrange
        let places = [ Place(id: 1000, location: testLocation) ]
        let area = LocationArea(location: testLocation, distance: 10.0)
        repository.readHandler = { _ in successAnswer(places) }

        // Act
        let result = try awaitPublisher(getPlaces(area))

        // Assert
        XCTAssertEqual(result.0, testLocation)
        XCTAssertEqual(result.1, places)
    }

    func testExecuteError() throws {
        // Arrange
        let area = LocationArea(location: testLocation, distance: 10.0)
        repository.readHandler = { _ in failAnswer() }

        // Act
        let result = try awaitError(getPlaces(area))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
}
