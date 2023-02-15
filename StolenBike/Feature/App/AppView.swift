//
//  AppView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<App>

    var body: some View {
        WithViewStore(store, observe: \.tab) { viewStore in
            TabView(selection: viewStore.binding(get: { $0 },
                                                 send: App.Action.selectTab)) {
                BikeMapView(store: store
                    .scope(state: \.bikeMap, action: App.Action.bikeMap))
                .tabItem {
                    Label("Search", systemImage: "map")
                }
                .tag(App.Tab.bikeMap)

                RegisterBikeView(store: store
                    .scope(state: \.registerBike, action: App.Action.registerBike))
                .tabItem {
                    Label("Register", systemImage: "bicycle")
                }
                .tag(App.Tab.registerBike)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: .init(initialState: .init(), reducer: App()))
    }
}
