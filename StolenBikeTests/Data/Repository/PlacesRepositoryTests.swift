//
//  PlacesRepositoryTests.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 11.10.2022.
//

import XCTest

@testable import StolenBike

final class PlacesRepositoryTests: XCTestCase {
    private var network: NetworkMock!
    private var mapper: MapperMock<PlaceDTO, Place>!
    private var repository: DefaultPlacesRepository!
    private let testLocation = Location(latitude: 200.0, longitude: 200.0)

    override func setUp() {
        super.setUp()

        network = NetworkMock()
        mapper = MapperMock<PlaceDTO, Place>()
        repository = DefaultPlacesRepository(network: network, mapper: mapper)
    }

    func testRead() throws {
        // Arrange
        let area = LocationArea(location: testLocation, distance: 10.0)
        let places = [ Place(id: 1000, location: testLocation) ]
        network.requestHandler = { _ in successAnswer(self.getData(id: 1000)) }
        mapper.callMapHandler = { _ in places[0] }

        // Act
        let result = try awaitPublisher(repository.read(area: area))

        // Assert
        XCTAssertEqual(result, places)
    }

    func testReadEmpty() throws {
        // Arrange
        let area = LocationArea(location: testLocation, distance: 10.0)
        network.requestHandler = { _ in successAnswer(self.getDataWithoutCoordinates()) }

        // Act
        let result = try awaitPublisher(repository.read(area: area))

        // Assert
        XCTAssertEqual(result, [])
    }

    func testReadNetworkError() throws {
        // Arrange
        let area = LocationArea(location: testLocation, distance: 10.0)
        network.requestHandler = { _ in failAnswer() }

        // Act
        let result = try awaitError(repository.read(area: area))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }

    private func getData(id: Int) -> Data {
        Data("""
            {
                "bikes": [{
                    "id": \(id),
                    "stolen_coordinates": [20.0, 20.0]
                }]
            }
            """.utf8)
    }

    private func getDataWithoutCoordinates() -> Data {
        Data("""
            {
                "bikes": [{
                    "id": 1000
                }]
            }
            """.utf8)
    }
}
