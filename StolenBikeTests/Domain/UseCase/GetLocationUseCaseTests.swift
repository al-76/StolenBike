//
//  GetLocationUseCaseTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 07.10.2022.
//

import XCTest

@testable import StolenBike

final class GetLocationUseCaseTests: XCTestCase {
    private var repository: LocationRepositoryMock!
    private var getLocation: GetLocationUseCase!

    override func setUp() {
        super.setUp()

        repository = LocationRepositoryMock()
        getLocation = GetLocationUseCase(repository: repository)
    }

    func testExecute() throws {
        // Arrange
        let testData = Location(latitude: 200.0, longitude: 200.0)
        repository.readHandler = { successAnswer(testData) }

        // Act
        let result = try awaitPublisher(getLocation())

        // Assert
        XCTAssertEqual(result, testData)
    }

    func testExecuteError() throws {
        // Arrange
        repository.readHandler = { failAnswer() }

        // Act
        let result = try awaitError(getLocation())

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
}
