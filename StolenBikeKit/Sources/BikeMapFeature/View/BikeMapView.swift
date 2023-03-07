//
//  BikeMapView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import CoreLocationUI
import ComposableArchitecture
import MapKit
import SwiftUI

import BikeClient
import MapView
import SharedModel
import Utils

public struct BikeMapView: View {
    private let store: StoreOf<BikeMap>
    @State private var showSettings = false

    public init(store: StoreOf<BikeMap>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                mapView(viewStore)

                VStack {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .onTapGesture {
                                showSettings.toggle()
                            }
                        TextField("Type something to filter...",
                                  text: viewStore.binding(
                                    get: \.query,
                                    send: { .updateQuery($0) }
                                  ))
                    }
                    .mapElement(opacity: 0.95)
                    .padding()

                    errorView(viewStore)

                    Spacer()
                    if viewStore.isLoading {
                        ProgressView("Loading...")
                            .mapElement()
                    }

                    if viewStore.isOutOfArea {
                        VStack {
                            Text("You're out of the initial area!")
                            Button("Change area") {
                                viewStore.send(.changeArea)
                            }
                        }
                        .mapElement()
                    }

                    Spacer()
                    HStack {
                        Button {

                        } label: {
                            Image(systemName: "list.bullet.rectangle")
                        }
                        .mapElement()
                        .badge(count: viewStore.fetchCount)
                        .padding()

                        LocationButton {
                            viewStore.send(.getLocation)
                        }
                        .symbolVariant(.fill)
                        .cornerRadius(8.0)
                        .foregroundColor(.white)
                        .padding()
                        Spacer()
                    }
                }
            }
            .onAppear {
                viewStore.send(.getLocation)
            }
            .onChange(of: viewStore.area) { _ in
                viewStore.send(.fetch)
            }
            .task(id: viewStore.query) {
                do {
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
                    viewStore.send(.fetch)
                } catch {
                    // TODO: Handle an error
                }
            }
            .sheet(isPresented: $showSettings) {
                BikeMapSettingsView(store: store.scope(
                    state: \.settings,
                    action: BikeMap.Action.settings
                ))
            }
        }
    }

    @ViewBuilder
    private func mapView(_ viewStore: ViewStore<BikeMap.State, BikeMap.Action>) -> some View {
        if _XCTIsTesting { // Snapshot testing doesn't work with maps
            EmptyView()
        } else {
            MapView(region: viewStore.binding(
                get: \.region,
                send: { .updateRegion($0) }
            ),
                    annotations: viewStore.bikes
                .compactMap { $0.pointAnnotation() },
                    overlays: mapOverlays(viewStore.area))
            .edgesIgnoringSafeArea(.top)
        }
    }

    private func errorView(_ viewStore: ViewStore<BikeMap.State, BikeMap.Action>) -> some View {
        VStack {
            if let error = viewStore.locationError?.error {
                ErrorView(title: "Location error",
                          error: error) {
                    viewStore.send(.getLocation)
                }
            }

            if let error = viewStore.fetchError?.error {
                ErrorView(title: "Fetch error",
                          error: error) {
                    viewStore.send(.fetch)
                }
            }
        }
    }

    private func mapOverlays(_ area: LocationArea?) -> [any MapOverlay] {
        guard let area else { return [] }
        return [AreaCircle(area: area)]
    }
}

private final class PointAnnotation: MKPointAnnotation, MapViewPointAnnotation {
    var id: Int = 0
    var glyphImageName: String = "bicycle.circle.fill"

    init(id: Int, coordinate: CLLocationCoordinate2D) {
        super.init()

        self.id = id
        self.coordinate = coordinate
    }
}

private final class AreaCircle: MKCircle, MapOverlay {
    var renderer: MKOverlayRenderer {
        let renderer = MKCircleRenderer(circle: MKCircle(center: coordinate,
                                                         radius: radius))
        renderer.lineWidth = 5.0
        renderer.strokeColor = .red
        renderer.alpha = 0.5
        return renderer
    }

    convenience init(area: LocationArea) {
        self.init(center: area.location.coordinates(),
                  radius: area.radius)
    }
}

private extension Bike {
    func pointAnnotation() -> PointAnnotation? {
        guard let location = stolenLocation else { return nil }
        return PointAnnotation(id: id, coordinate: location.coordinates())
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapView(store: .init(initialState: .init(),
                                 reducer: BikeMap()))
    }
}
