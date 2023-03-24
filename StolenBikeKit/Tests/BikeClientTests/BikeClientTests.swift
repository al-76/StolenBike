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

    func testFetchDetailsDecode() throws {
        // Arrange
        let data = Data("""
        {
          "bike": {
            "date_stolen": 1679280446,
            "description": null,
            "frame_colors": [
              "Blue"
            ],
            "frame_model": "Backwoods",
            "id": 1472201,
            "is_stock_img": false,
            "large_img": "https://files.bikeindex.org/uploads/Pu/679958/large_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg",
            "location_found": null,
            "manufacturer_name": "GT Bicycles",
            "external_id": null,
            "registry_name": null,
            "registry_url": null,
            "serial": "Unknown",
            "status": "stolen",
            "stolen": true,
            "stolen_coordinates": [32.74, -117.12],
            "stolen_location": "San Diego, CA 92104, US",
            "thumb": "https://files.bikeindex.org/uploads/Pu/679958/small_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg",
            "title": "GT Bicycles Backwoods",
            "url": "https://bikeindex.org/bikes/1472201",
            "year": null,
            "registration_created_at": 1679280511,
            "registration_updated_at": 1679335170,
            "api_url": "https://bikeindex.org/api/v1/bikes/1472201",
            "manufacturer_id": 119,
            "paint_description": null,
            "name": null,
            "frame_size": null,
            "rear_tire_narrow": true,
            "front_tire_narrow": null,
            "type_of_cycle": "Bike",
            "test_bike": false,
            "rear_wheel_size_iso_bsd": null,
            "front_wheel_size_iso_bsd": null,
            "handlebar_type_slug": null,
            "frame_material_slug": null,
            "front_gear_type_slug": null,
            "rear_gear_type_slug": null,
            "extra_registration_number": null,
            "additional_registration": null,
            "stolen_record": {
              "date_stolen": 1679280446,
              "location": "San Diego, CA 92104, US",
              "latitude": 32.74,
              "longitude": -117.12,
              "theft_description": null,
              "locking_description": null,
              "lock_defeat_description": null,
              "police_report_number": null,
              "police_report_department": null,
              "created_at": 1679280511,
              "create_open311": false,
              "id": 141067
            },
            "public_images": [
              {
                "name": "GT Bicycles Backwoods Blue",
                "full": "https://files.bikeindex.org/uploads/Pu/679958/0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg",
                "large": "https://files.bikeindex.org/uploads/Pu/679958/large_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg",
                "medium": "https://files.bikeindex.org/uploads/Pu/679958/medium_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg",
                "thumb": "https://files.bikeindex.org/uploads/Pu/679958/small_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg",
                "id": 679958
              },
              {
                "name": "GT Bicycles Backwoods Blue",
                "full": "https://files.bikeindex.org/uploads/Pu/679959/151B0C84-B541-4B5A-8016-7F972FF43D7A.png",
                "large": "https://files.bikeindex.org/uploads/Pu/679959/large_151B0C84-B541-4B5A-8016-7F972FF43D7A.png",
                "medium": "https://files.bikeindex.org/uploads/Pu/679959/medium_151B0C84-B541-4B5A-8016-7F972FF43D7A.png",
                "thumb": "https://files.bikeindex.org/uploads/Pu/679959/small_151B0C84-B541-4B5A-8016-7F972FF43D7A.png",
                "id": 679959
              }
            ]
          }
        }
        """.utf8)
        let expectedDetails: BikeDetails = .stub

        // Act
        let details = try BikeClient.fetchDecoder
            .decode(BikeClient.ResponseDetails.self, from: data)
            .bike

        // Assert
        XCTAssertNoDifference(details, expectedDetails)
    }

    func testSnapshotModel() throws {
        // Arrange
        let data: [Bike] = .stub

        // Assert
        assertSnapshot(matching: data, as: .dump)
    }
}
