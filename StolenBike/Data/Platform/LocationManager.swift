//
//  LocationManager.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 06.10.2022.
//

import Foundation
import Combine

/// @mockable
protocol LocationManager {
    typealias OnGetLocation = (Result<Location, Error>) -> Void

    func getLocation(onGetLocation: @escaping OnGetLocation)
}
