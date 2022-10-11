//
//  PlatformContainer.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 06.10.2022.
//

import Foundation
import Factory

final class PlatformContainer: SharedContainer {
    static let getLocationManager = Factory {
        DefaultLocationManager()
    }

    static let getNetwork = Factory {
        DefaultNetwork()
    }
}
