//
//  LocationRepositoryTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 07.10.2022.
//

import XCTest

@testable import StolenBike

final class LocationRepositoryTests: XCTestCase {
    private var locationManager: LocationManagerMock!
    private var repository: DefaultLocationRepository!
    private let location = Location(latitude: 200.0, longitude: 200.0)

    override func setUp() {
        super.setUp()

        locationManager = LocationManagerMock()
        repository = DefaultLocationRepository(locationManager: locationManager)
    }

    func testRead() throws {
        // Arrange
        let testData = location
        locationManager.getLocationHandler = { $0(.success(testData)) }

        // Act
        let result = try awaitPublisher(repository.read())

        // Assert
        XCTAssertEqual(result, testData)
    }

    func testReadError() throws {
        // Arrange
        locationManager.getLocationHandler = { $0(.failure(TestError.someError)) }

        // Act
        let result = try awaitPublisher(repository.read())

        // Assert
        XCTAssertEqual(result, DefaultLocationRepository.defaultLocation)
    }
}
