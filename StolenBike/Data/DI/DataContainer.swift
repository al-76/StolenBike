//
//  DataContainer.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 06.10.2022.
//

import Foundation
import Factory

final class DataContainer: SharedContainer {
    static let getLocationRepository = Factory {
        DefaultLocationRepository(locationManager: PlatformContainer.getLocationManager())
    }

    static let getPlacesRepository = Factory {
        DefaultPlacesRepository(network: PlatformContainer.getNetwork(),
                                mapper: PlaceMapper())
    }
}
