//
//  Bike.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 03.10.2022.
//

import Foundation

import SharedModel

public struct Bike: Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let stolenLocation: Location?
    public let dateStolen: Date?
    public let frameColors: [String]
    public let frameModel: String?
    public let largeImageUrl: URL?
    public let thumbImageUrl: URL?
    public let manufacturerName: String
    public let serial: String
    public let year: Int?

    public init(id: Int,
                title: String,
                stolenLocation: Location?,
                dateStolen: Date?,
                frameColors: [String],
                frameModel: String?,
                largeImageUrl: URL?,
                thumbImageUrl: URL?,
                manufacturerName: String,
                serial: String,
                year: Int?) {
        self.id = id
        self.title = title
        self.stolenLocation = stolenLocation
        self.dateStolen = dateStolen
        self.frameColors = frameColors
        self.frameModel = frameModel
        self.largeImageUrl = largeImageUrl
        self.thumbImageUrl = thumbImageUrl
        self.manufacturerName = manufacturerName
        self.serial = serial
        self.year = year
    }
}
