//
//  BikeMapSettingsView.swift
//  
//
//  Created by Vyacheslav Konopkin on 25.02.2023.
//

import ComposableArchitecture
import SwiftUI

public struct BikeMapSettingsView: View {
    private let store: StoreOf<BikeMapSettings>

    public init(store: StoreOf<BikeMapSettings>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("Search settings")
                    .font(.headline)
                Spacer()
                Toggle("Global search",
                       isOn: viewStore.binding(
                        get: \.isGlobalSearch,
                        send: { .updateIsGlobalSearch($0) }
                       ))
                Spacer()
            }
            .padding()
        }
    }
}

struct BikeMapSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapSettingsView(store: .init(initialState: .init(),
                                         reducer: BikeMapSettings()))
    }
}
