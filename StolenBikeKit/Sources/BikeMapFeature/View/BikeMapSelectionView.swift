//
//  BikeMapSelectionView.swift
//  
//
//  Created by Vyacheslav Konopkin on 01.04.2023.
//

import ComposableArchitecture
import SwiftUI

import BikeClient

struct BikeMapSelectionView: View {
    var store: StoreOf<BikeMapSelection>

    @State private var text = ""

    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.bikes.count == 1 {
                BikeMapDetailsView(id: viewStore.bikes[0].id,
                                   store: store.scope(
                                    state: \.details,
                                    action: BikeMapSelection.Action.details
                                   ))
            } else {
                NavigationStack {
                    List(viewStore.filteredBikes) { bike in
                        NavigationLink(value: bike) {
                            BikeMapRowView(bike: bike)
                        }
                    }
                    .navigationDestination(for: Bike.self) {
                        BikeMapDetailsView(id: $0.id,
                                           store: store.scope(
                                            state: \.details,
                                            action: BikeMapSelection.Action.details
                                           ))
                    }
                    .navigationTitle("Selected bikes")
                    .searchable(text: viewStore.binding(
                        get: \.filter,
                        send: { .updateFilter($0) }
                    ))
                }
            }
        }
    }
}

struct BikeMapSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapSelectionView(store: .init(
            initialState: .init(bikes: .stub),
            reducer: BikeMapSelection())
        )
        .previewDisplayName("Multiple bikes selected")

        BikeMapSelectionView(store: .init(
            initialState: .init(bikes: [Bike.stub]),
            reducer: BikeMapSelection())
        )
        .previewDisplayName("One bike selected")
    }
}
