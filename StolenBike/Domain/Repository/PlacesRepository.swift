//
//  PlacesRepository.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 06.10.2022.
//

import Foundation
import Combine

/// @mockable
protocol PlacesRepository {
    func read(area: LocationArea) -> AnyPublisher<[Place], Error>
}
