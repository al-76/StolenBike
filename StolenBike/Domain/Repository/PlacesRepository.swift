//
//  PlacesRepository.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 06.10.2022.
//

import Foundation
import Combine

protocol PlacesRepository {
    func read() -> AnyPublisher<[Place], Error>
}
