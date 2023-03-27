//
//  BikeMapListView.swift
//  
//
//  Created by Vyacheslav Konopkin on 08.03.2023.
//

import ComposableArchitecture
import SwiftUI

import BikeClient
import SearchBarView

struct BikeMapListView: View {
    let store: StoreOf<BikeMapList>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                List(viewStore.bikes) { bike in
                    NavigationLink(value: bike) {
                        BikeMapRowView(bike: bike)
                    }
                    .onAppear {
                        viewStore.send(.fetchMore(bike))
                    }
                }
                .refreshable {
                    await viewStore.send(.fetch, while: \.isLoading)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Bike.self) {
                    BikeMapDetailsView(id: $0.id,
                                       store: store.scope(
                                        state: \.details,
                                        action: BikeMapList.Action.details
                                       ))
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(alignment: .leading) {
                            SearchBarView("Type to find a bike...",
                                          text: viewStore.binding(
                                            get: \.query,
                                            send: { .updateQuery($0) }
                                          ))
                            .padding(.top, 6)
                        }
                    }
                }
                if viewStore.isLoading {
                    ProgressView("Fetching bikes 🚲...")
                }
            }
            .task(id: viewStore.query) {
                do {
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
                    await viewStore.send(.updateQueryDebounced).finish()
                } catch {
                    // TODO: Handle an error
                }
            }
        }
    }
}

struct BikeMapListView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapListView(store: .init(
            initialState: .init(bikes: .stub),
            reducer: BikeMapList()
        ))
    }
}
