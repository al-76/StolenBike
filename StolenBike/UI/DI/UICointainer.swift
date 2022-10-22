//
//  UICointainer.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 05.10.2022.
//

import Foundation
import Factory

final class UIContainer: SharedContainer {
    static let getMapViewModel = Factory {
        MapViewModel(getLocation: DomainContainer.getLocationUseCase(),
                     getPlaces: DomainContainer.getPlacesUseCase(),
                     debounceScheduler: DispatchQueue.main)
    }
}
