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
    @State var text = ""
    @Binding var detendId: UISheetPresentationController.Detent.Identifier

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                if detendId != .fraction {
                    Picker("Search mode",
                           selection: viewStore.binding(
                            get: \.searchMode,
                            send: { .updateSearchMode($0) }
                           )
                    ) {
                        Text("Local stolen")
                            .tag(BikeMapList.SearchMode.localStolen)
                        Text("All stolen")
                            .tag(BikeMapList.SearchMode.allStolen)
                        Text("All non-stolen")
                            .tag(BikeMapList.SearchMode.allNonStolen)
                        Text("All")
                            .tag(BikeMapList.SearchMode.all)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                }

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
                        SearchBarView("Manufacturer, serial, color or something else...",
                                      text: viewStore.binding(
                                        get: \.query,
                                        send: { .updateQuery($0) }
                                      ))
                        .padding(.top, 6)
                        .onTapGesture {
                            guard detendId == .fraction else { return }
                            detendId = .large
                        }
                    }
                }

                if detendId != .fraction,
                   viewStore.isLoading {
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
        ),
                        detendId: .constant(.fraction))
    }
}
