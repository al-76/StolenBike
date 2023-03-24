//
//  BikeClientTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 21.02.2023.
//

import Foundation
import ComposableArchitecture
import SnapshotTesting
import XCTest

import SharedModel

@testable import BikeClient

final class BikeClientTests: XCTestCase {
    override func setUp() {
//        isRecording = true
    }

    func testFetchDecode() throws {
        // Arrange
        let data = Data("""
        {
        "bikes":[
            {
                "id": 1467483,
                "title": "2021 Rad Power Bikes Rad MiniST(White)",
                "stolen_coordinates": [37.31, -122.07],
                "date_stolen": 1678052700,
                "thumb": "https://files.bikeind.org/uploads/Pu/677396/small_20211028_1459.jpg"
            },
            {
                "id": 100500,
                "title": "Haro Shredder pro",
                "stolen_coordinates": null,
                "date_stolen": null,
                "thumb": null
            }
        ]
        }
        """.utf8)
        let expectedBikes = [
            Bike(id: 1467483,
                 title: "2021 Rad Power Bikes Rad MiniST(White)",
                 stolenCoordinates: [37.31, -122.07],
                 dateStolen: Date(timeIntervalSince1970: 1678052700),
                 thumb: URL(string: "https://files.bikeind.org/uploads/Pu/677396/small_20211028_1459.jpg")),
            Bike(id: 100500,
                 title: "Haro Shredder pro",
                 stolenCoordinates: nil,
                 dateStolen: nil,
                 thumb: nil)
        ]

        // Act
        let bikes = try BikeClient.fetchDecoder
            .decode(BikeClient.Response.self, from: data)
            .bikes

        // Assert
        XCTAssertNoDifference(bikes, expectedBikes)
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
        let data: [Bike] = .stub

        // Assert
        assertSnapshot(matching: data, as: .dump)
    }
}
