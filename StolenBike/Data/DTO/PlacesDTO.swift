//
//  PlacesDTO.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 09.10.2022.
//

import Foundation

struct PlacesDTO: Decodable {
    let places: [PlaceDTO]
}

extension PlacesDTO {
    enum CodingKeys: String, CodingKey {
        case places = "bikes"
    }
}

struct PlaceDTO: Decodable {
    let id: Int
    let location: [Double]?
}

extension PlaceDTO {
    enum CodingKeys: String, CodingKey {
        case id
        case location = "stolen_coordinates"
    }
}
