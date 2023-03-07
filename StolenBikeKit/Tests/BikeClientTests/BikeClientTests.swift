//
//  BikeClientTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 21.02.2023.
//

import Foundation
import SnapshotTesting
import XCTest

import SharedModel

@testable import BikeClient

final class BikeClientTests: XCTestCase {
    func testFetchDecode() throws {
        // Arrange
        let data = Data("""
        {
        "bikes":[
            {
                "id":1435627,
                "stolen_coordinates":[
                    37.35,
                    -122.03
                ],
            },
            {
                "id":1238267,
                "stolen_coordinates":[
                    37.35,
                    -122.04
                ],
            },
            {
                "id":100500,
                "stolen_coordinates":null
            }
        ]
        }
        """.utf8)
        let expectedBikes = [
            Bike(id: 1435627, stolenLocation: Location(latitude: 37.35,
                                                       longitude: -122.03)),
            Bike(id: 1238267, stolenLocation: Location(latitude: 37.35,
                                                       longitude: -122.04)),
            Bike(id: 100500, stolenLocation: nil)
        ]

        // Act
        let bikes = try JSONDecoder()
            .decode(BikeClient.Response.self, from: data)
            .bikes

        // Assert
        XCTAssertEqual(bikes, expectedBikes)
    }

    func testFetchCountDecode() throws {
        // Arrange
        let data = Data("""
        {
            "stolen":10000,
            "proximity":100
        }
        """.utf8)
        let expectedCount = (stolen: 10000, proximity: 100)

        // Act
        let count = try JSONDecoder()
            .decode(BikeClient.ResponseCount.self, from: data)

        // Assert
        XCTAssertEqual(count.stolen, expectedCount.stolen)
        XCTAssertEqual(count.proximity, expectedCount.proximity)
    }

    func testSnapshotModel() throws {
        // Arrange
        let data = [Bike].stub

        // Assert
        assertSnapshot(matching: data, as: .dump)
    }
}
