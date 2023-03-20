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
    override func setUp() {
//        isRecording = true
    }

    func testFetchDecode() throws {
        // Arrange
        let data = Data("""
        {
        "bikes":[
            {
                "id":1467483,
                "title":"2021 Rad Power Bikes Rad MiniST(White)",
                "stolen_coordinates":[37.31,-122.07],
                "date_stolen":1678052700,
                "frame_colors":["White"],
                "frame_model":"Rad Mini ST (White)",
                "large_img":"https://files.bikeind.org/uploads/Pu/677396/large_20211028_1459.jpg",
                "thumb":"https://files.bikeind.org/uploads/Pu/677396/small_20211028_1459.jpg",
                "manufacturer_name":"Rad Power Bikes",
                "serial":"MU2A21J1704",
                "year":2021
            },
            {
                "id":100500,
                "title":"Haro Shredder pro",
                "stolen_coordinates":null,
                "date_stolen":null,
                "frame_colors":["Black"],
                "frame_model":null,
                "large_img":null,
                "thumb":null,
                "manufacturer_name":"Haro",
                "serial":"Hidden",
                "year":null
            }
        ]
        }
        """.utf8)
        let expectedBikes = [
            Bike(id: 1467483,
                 title: "2021 Rad Power Bikes Rad MiniST(White)",
                 stolenLocation: Location(latitude: 37.31, longitude: -122.07),
                 dateStolen: Date(timeIntervalSince1970: 1678052700),
                 frameColors: ["White"],
                 frameModel: "Rad Mini ST (White)",
                 largeImageUrl: URL(string: "https://files.bikeind.org/uploads/Pu/677396/large_20211028_1459.jpg"),
                 thumbImageUrl: URL(string: "https://files.bikeind.org/uploads/Pu/677396/small_20211028_1459.jpg"),
                 manufacturerName: "Rad Power Bikes",
                 serial: "MU2A21J1704",
                 year: 2021),
            Bike(id: 100500,
                 title: "Haro Shredder pro",
                 stolenLocation: nil,
                 dateStolen: nil,
                 frameColors: ["Black"],
                 frameModel: nil,
                 largeImageUrl: nil,
                 thumbImageUrl: nil,
                 manufacturerName: "Haro",
                 serial: "Hidden",
                 year: nil)
        ]

        // Act
        let bikes = try BikeClient.fetchDecoder
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
