//
//  UICointainer.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 05.10.2022.
//

import Foundation
import Factory

final class UIContainer: SharedContainer {
    static let getBikeMapViewModel = Factory {
        BikeMapViewModel(getLocation: DomainContainer.getLocationUseCase(),
                         getPlaces: DomainContainer.getPlacesUseCase(),
                         debounceScheduler: DispatchQueue.main)
    }
}
