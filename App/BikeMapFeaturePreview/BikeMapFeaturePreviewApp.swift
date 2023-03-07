//
//  BikeMapFeaturePreviewApp.swift
//  BikeMapFeaturePreview
//
//  Created by Vyacheslav Konopkin on 06.03.2023.
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
