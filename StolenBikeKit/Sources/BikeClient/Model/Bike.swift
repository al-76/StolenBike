//
//  Bike.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 03.10.2022.
//

import Foundation

import SharedModel

public struct Bike: Identifiable, Equatable, Decodable, Hashable {
    public let id: Int
    public let title: String

    private let stolenCoordinates: [Double]?
    public var location: Location? {
        guard let stolenCoordinates else { return nil }
        return Location(latitude: stolenCoordinates[0],
                        longitude: stolenCoordinates[1])
    }

    public let dateStolen: Date?
    public let thumb: URL?

    public init(id: Int,
                title: String,
                stolenCoordinates: [Double]?,
                dateStolen: Date?,
                thumb: URL?) {
        self.id = id
        self.title = title
        self.stolenCoordinates = stolenCoordinates
        self.dateStolen = dateStolen
        self.thumb = thumb
    }
}
