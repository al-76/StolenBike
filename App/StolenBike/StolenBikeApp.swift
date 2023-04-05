//
//  StolenBikeApp.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import SwiftUI

import BikeMapFeature

@main
struct StolenBikeApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            BikeMapView(store: .init(initialState: .init(),
                                     reducer: BikeMap()))
        }
    }
}
