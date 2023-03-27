//
//  File.swift
//  
//
//  Created by Vyacheslav Konopkin on 22.03.2023.
//

import Foundation

import SharedModel

extension BikeDetails {
    public static let stub = BikeDetails(
        dateStolen: Date(timeIntervalSince1970: 1679280446),
        description: nil,
        frameColors: ["Blue"],
        frameModel: "Backwoods",
        id: 1472201,
        isStockImg: false,
        largeImg: URL(string: "https://files.bikeindex.org/uploads/Pu/679958/large_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg"),
        locationFound: nil,
        manufacturerName: "GT Bicycles",
        externalId: nil,
        registryName: nil,
        registryUrl: nil, serial: "Unknown",
        status: "stolen",
        stolen: true,
        stolenCoordinates: [ 32.74, -117.12],
        stolenLocation: "San Diego, CA 92104, US",
        thumb: URL(string: "https://files.bikeindex.org/uploads/Pu/679958/small_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg"),
        title: "GT Bicycles Backwoods",
        url: URL(string: "https://bikeindex.org/bikes/1472201"),
        year: nil,
        registrationCreatedAt: Date(timeIntervalSince1970: 1679280511),
        registrationUpdatedAt: Date(timeIntervalSince1970: 1679335170),
        apiUrl: URL(string: "https://bikeindex.org/api/v1/bikes/1472201"),
        manufacturerId: 119,
        paintDescription: nil,
        name: nil,
        frameSize: "60cm",
        rearTireNarrow: true,
        frontTireNarrow: nil,
        typeOfCycle: "Bike",
        testBike: false,
        rearWheelSizeIsoBsd: nil,
        frontWheelSizeIsoBsd: nil,
        handlebarTypeSlug: nil,
        frameMaterialSlug: "Iron",
        frontGearTypeSlug: nil,
        rearGearTypeSlug: nil,
        extraRegistrationNumber: "2048",
        additionalRegistration: "2048",
        publicImages: [
            BikeImage(
                name: "GT Bicycles Backwoods Blue",
                full: URL(string: "https://files.bikeindex.org/uploads/Pu/679958/0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg"),
                large: URL(string: "https://files.bikeindex.org/uploads/Pu/679958/large_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg"),
                medium: URL(string: "https://files.bikeindex.org/uploads/Pu/679958/medium_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg"),
                thumb: URL(string: "https://files.bikeindex.org/uploads/Pu/679958/small_0AD24935-8E01-4956-A37E-4CD43EA75CA0.jpeg"),
                id: 679958
            ),
            BikeImage(
                name: "GT Bicycles Backwoods Blue",
                full: URL(string: "https://files.bikeindex.org/uploads/Pu/679959/151B0C84-B541-4B5A-8016-7F972FF43D7A.png"),
                large: URL(string: "https://files.bikeindex.org/uploads/Pu/679959/large_151B0C84-B541-4B5A-8016-7F972FF43D7A.png"),
                medium: URL(string: "https://files.bikeindex.org/uploads/Pu/679959/medium_151B0C84-B541-4B5A-8016-7F972FF43D7A.png"),
                thumb: URL(string: "https://files.bikeindex.org/uploads/Pu/679959/small_151B0C84-B541-4B5A-8016-7F972FF43D7A.png"),
                id: 679959
            )
        ],
        stolenRecord: BikeStolenRecord(
            dateStolen: Date(timeIntervalSince1970: 1679280446),
            location: "San Diego, CA 92104, US",
            latitude: 32.74,
            longitude: -117.12,
            theftDescription: nil,
            lockingDescription: nil,
            lockDefeatDescription: nil,
            policeReportNumber: "1024",
            policeReportDepartment: "NY",
            createdAt: Date(timeIntervalSince1970: 1679280511),
            createOpen311: false,
            id: 141067
        )
    )
}
