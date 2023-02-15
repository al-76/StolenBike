//
//  StolenBikeApp.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import SwiftUI
import XCTestDynamicOverlay

@main
struct StolenBikeApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                AppView(store: .init(initialState: .init(),
                                     reducer: App()))
            }
        }
    }
}
