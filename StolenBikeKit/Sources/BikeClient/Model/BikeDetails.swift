//
//  BikeDetails.swift
//  
//
//  Created by Vyacheslav Konopkin on 22.03.2023.
//

import Foundation

import SharedModel

public struct BikeDetails: Equatable, Decodable {
    public let dateStolen: Date?
    public let description: String?
    public let frameColors: [String]?
    public let frameModel: String?
    public let id: Int
    public let isStockImg: Bool?
    public let largeImg: URL?
    public let locationFound: String?
    public let manufacturerName: String?
    public let externalId: String?
    public let registryName: String?
    public let registryUrl: String?
    public let serial: String?
    public let status: String?
    public let stolen: Bool?

    private let stolenCoordinates: [Double]?
    public var location: Location? {
        guard let stolenCoordinates else { return nil }
        return Location(latitude: stolenCoordinates[0],
                        longitude: stolenCoordinates[1])
    }

    public let stolenLocation: String?
    public let thumb: URL?
    public let title: String?
    public let url: URL?
    public let year: Int?
    public let registrationCreatedAt: Date?
    public let registrationUpdatedAt: Date?
    public let apiUrl: URL?
    public let manufacturerId: Int?
    public let paintDescription: String?
    public let name: String?
    public let frameSize: String?
    public let rearTireNarrow: Bool?
    public let frontTireNarrow: Bool?
    public let typeOfCycle: String?
    public let testBike: Bool?
    public let rearWheelSizeIsoBsd: Int?
    public let frontWheelSizeIsoBsd: Int?
    public let handlebarTypeSlug: String?
    public let frameMaterialSlug: String?
    public let frontGearTypeSlug: String?
    public let rearGearTypeSlug: String?
    public let extraRegistrationNumber: String?
    public let additionalRegistration: String?
    public let publicImages: [BikeImage]?
    public let stolenRecord: BikeStolenRecord?

    public init(dateStolen: Date?,
                description: String?,
                frameColors: [String]?,
                frameModel: String?,
                id: Int,
                isStockImg: Bool?,
                largeImg: URL?,
                locationFound: String?,
                manufacturerName: String?,
                externalId: String?,
                registryName: String?,
                registryUrl: String?,
                serial: String?,
                status: String?,
                stolen: Bool?,
                stolenCoordinates: [Double]?,
                stolenLocation: String?,
                thumb: URL?,
                title: String?,
                url: URL?,
                year: Int?,
                registrationCreatedAt: Date?,
                registrationUpdatedAt: Date?,
                apiUrl: URL?,
                manufacturerId: Int?,
                paintDescription: String?,
                name: String?,
                frameSize: String?,
                rearTireNarrow: Bool?,
                frontTireNarrow: Bool?,
                typeOfCycle: String?,
                testBike: Bool?,
                rearWheelSizeIsoBsd: Int?,
                frontWheelSizeIsoBsd: Int?,
                handlebarTypeSlug: String?,
                frameMaterialSlug: String?,
                frontGearTypeSlug: String?,
                rearGearTypeSlug: String?,
                extraRegistrationNumber: String?,
                additionalRegistration: String?,
                publicImages: [BikeImage]?,
                stolenRecord: BikeStolenRecord?) {
        self.dateStolen = dateStolen
        self.description = description
        self.frameColors = frameColors
        self.frameModel = frameModel
        self.id = id
        self.isStockImg = isStockImg
        self.largeImg = largeImg
        self.locationFound = locationFound
        self.manufacturerName = manufacturerName
        self.externalId = externalId
        self.registryName = registryName
        self.registryUrl = registryUrl
        self.serial = serial
        self.status = status
        self.stolen = stolen
        self.stolenCoordinates = stolenCoordinates
        self.stolenLocation = stolenLocation
        self.thumb = thumb
        self.title = title
        self.url = url
        self.year = year
        self.registrationCreatedAt = registrationCreatedAt
        self.registrationUpdatedAt = registrationUpdatedAt
        self.apiUrl = apiUrl
        self.manufacturerId = manufacturerId
        self.paintDescription = paintDescription
        self.name = name
        self.frameSize = frameSize
        self.rearTireNarrow = rearTireNarrow
        self.frontTireNarrow = frontTireNarrow
        self.typeOfCycle = typeOfCycle
        self.testBike = testBike
        self.rearWheelSizeIsoBsd = rearWheelSizeIsoBsd
        self.frontWheelSizeIsoBsd = frontWheelSizeIsoBsd
        self.handlebarTypeSlug = handlebarTypeSlug
        self.frameMaterialSlug = frameMaterialSlug
        self.frontGearTypeSlug = frontGearTypeSlug
        self.rearGearTypeSlug = rearGearTypeSlug
        self.extraRegistrationNumber = extraRegistrationNumber
        self.additionalRegistration = additionalRegistration
        self.publicImages = publicImages
        self.stolenRecord = stolenRecord
    }
}

public struct BikeImage: Identifiable, Equatable, Decodable {
    public let name: String?
    public let full: URL?
    public let large: URL?
    public let medium: URL?
    public let thumb: URL?
    public let id: Int

    public init(name: String?,
                full: URL?,
                large: URL?,
                medium: URL?,
                thumb: URL?,
                id: Int) {
        self.name = name
        self.full = full
        self.large = large
        self.medium = medium
        self.thumb = thumb
        self.id = id
    }
}

public struct BikeStolenRecord: Equatable, Decodable {
    public let dateStolen: Date?
    public let location: String?

    private let latitude: Double?
    private let longitude: Double?
    public var stolenLocation: Location? {
        guard let latitude,
              let longitude else { return nil }
        return Location(latitude: latitude,
                        longitude: longitude)
    }

    public let theftDescription: String?
    public let lockingDescription: String?
    public let lockDefeatDescription: String?
    public let policeReportNumber: String?
    public let policeReportDepartment: String?
    public let createdAt: Date?
    public let createOpen311: Bool?
    public let id: Int?

    public init(dateStolen: Date?,
                location: String?,
                latitude: Double?,
                longitude: Double?,
                theftDescription: String?,
                lockingDescription: String?,
                lockDefeatDescription: String?,
                policeReportNumber: String?,
                policeReportDepartment: String?,
                createdAt: Date?,
                createOpen311: Bool?,
                id: Int?) {
        self.dateStolen = dateStolen
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.theftDescription = theftDescription
        self.lockingDescription = lockingDescription
        self.lockDefeatDescription = lockDefeatDescription
        self.policeReportNumber = policeReportNumber
        self.policeReportDepartment = policeReportDepartment
        self.createdAt = createdAt
        self.createOpen311 = createOpen311
        self.id = id
    }
}
