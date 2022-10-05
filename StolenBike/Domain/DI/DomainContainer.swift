//
//  DomainContainer.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 05.10.2022.
//

import Foundation
import Factory

final class DomainContainer: SharedContainer {
    static let getLocationUseCase = Factory {
        GetLocationUseCase()
    }

    static let getPlacesUseCase = Factory {
        GetPlacesUseCase()
    }
}
