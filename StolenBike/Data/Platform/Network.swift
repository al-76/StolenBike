//
//  Network.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 08.10.2022.
//

import Foundation
import Combine

/// @mockable
protocol Network {
    func request(url: URL) -> AnyPublisher<Data, Error>
}
