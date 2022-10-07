//
//  LocationRepository.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 06.10.2022.
//

import Foundation
import Combine

/// @mockable
protocol LocationRepository {
    func read() -> AnyPublisher<Location, Error>
}
