//
//  PlaceMapper.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 09.10.2022.
//

import Foundation

struct PlaceMapper: Mapper {
    func map(input: PlaceDTO) -> Place {
        Place(id: input.id, location: getLocation(input.location))
    }

    private func getLocation(_ location: [Double]?) -> Location {
        guard let location else {
            return Location(latitude: 0.0, longitude: 0.0)
        }
        return Location(latitude: location[0], longitude: location[1])
    }
}
