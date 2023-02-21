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
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testDecode() throws {
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

    func testModelHasntChanged() throws {
        assertSnapshot(matching: [Bike].stub, as: .dump)
    }
}
