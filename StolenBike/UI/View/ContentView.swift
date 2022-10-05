//
//  ContentView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BikeMapView()
                .tabItem {
                    Label("Search", systemImage: "map")
                }
            RegisterBikeView()
                .tabItem {
                    Label("Register", systemImage: "bicycle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
