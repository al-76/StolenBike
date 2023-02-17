//
//  StolenBikeApp.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import SwiftUI

import AppFeature

@main
struct StolenBikeApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            AppView(store: .init(initialState: .init(),
                                 reducer: App()))
        }
    }
}
