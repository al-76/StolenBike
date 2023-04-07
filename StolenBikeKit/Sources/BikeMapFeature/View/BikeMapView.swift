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
import BottomSheetView
import LocationClient
import MapView
import SharedModel
import Utils

public struct BikeMapView: View {
    private let store: StoreOf<BikeMap>
    @State private var isShownBikesSelection = false
    @State private var detentId: UISheetPresentationController.Detent.Identifier = .fraction

    public init(store: StoreOf<BikeMap>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                mapView(viewStore)
                VStack {
                    mapButtons(viewStore)
                    Spacer()
                }
            }
            .overlay {
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

                errorView(viewStore)
            }
            .onAppear {
                viewStore.send(.getLocation)
            }
            .bottomSheet(
                detents: [.fraction(0.050),
                          .medium(),
                          .large()],
                selectedDetentId: $detentId.animation()
            ) {
                BikeMapListView(store: store.scope(
                    state: \.list,
                    action: BikeMap.Action.list
                ),
                                detendId: $detentId)
                .sheet(isPresented: $isShownBikesSelection) {
                    BikeMapSelectionView(store: store.scope(
                        state: \.selection,
                        action: BikeMap.Action.selection)
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func mapView(_ viewStore: ViewStore<BikeMap.State, BikeMap.Action>) -> some View {
        if _XCTIsTesting { // Snapshot testing doesn't work with maps
            EmptyView()
        } else {
            MapView(
                region: viewStore.binding(
                    get: \.region,
                    send: { .updateRegion($0) }
                ),
                annotations: viewStore.bikes
                    .compactMap { $0.pointAnnotation() },
                overlays: mapOverlays(viewStore.area)
            ) { annotations in
                viewStore.send(.select(annotations.map { $0.id }))
                isShownBikesSelection = true
            }
            .edgesIgnoringSafeArea(.top)
        }
    }

    private func mapButtons(_ viewStore: ViewStore<BikeMap.State, BikeMap.Action>) -> some View {
        HStack {
            Spacer()
            VStack {
                LocationButton {
                    viewStore.send(.getLocation)
                }
                .labelStyle(.iconOnly)
                .symbolVariant(.fill)
                .cornerRadius()
                .foregroundColor(.white)

                CompassButtonView()
            }
            .padding()
        }
    }

    private func errorView(_ viewStore: ViewStore<BikeMap.State, BikeMap.Action>) -> some View {
        VStack {
            if let error = viewStore.locationError?.error {
                if let locationError = error as? LocationManagerError,
                   locationError == LocationManagerError.serviceIsNotAvailable {
                    ErrorView(title: "Location error",
                              tryAgainTitle: "Open settings",
                              error: error) {
                        viewStore.send(.openSettings)
                    } onCancel: {
                        viewStore.send(.locationErrorCancel)
                    }
                } else {
                    ErrorView(title: "Location error",
                              error: error) {
                        viewStore.send(.getLocation)
                    } onCancel: {
                        viewStore.send(.locationErrorCancel)
                    }
                }
            }

            if let error = viewStore.fetchError?.error {
                ErrorView(title: "Fetch error",
                          error: error) {
                    viewStore.send(.fetch)
                } onCancel: {
                    viewStore.send(.fetchErrorCancel)
                }
            }

            if let error = viewStore.settingsError?.error {
                ErrorView(title: "Settings error",
                          error: error) {
                    viewStore.send(.openSettings)
                } onCancel: {
                    viewStore.send(.settingsErrorCancel)
                }
            }
        }
    }

    private func mapOverlays(_ area: LocationArea?) -> [AreaCircle] {
        guard let area else { return [] }
        return [AreaCircle(area: area)]
    }
}

private final class PointAnnotation: MKPointAnnotation, MapViewPointAnnotation {
    let id: Int
    var glyphImageName: String = "bicycle.circle.fill"

    init(id: Int, coordinate: CLLocationCoordinate2D) {
        self.id = id
        super.init()

        self.coordinate = coordinate
    }
}

private final class AreaCircle: MKCircle, MapOverlay {
    private(set) var id: Int = 0

    var renderer: MKOverlayRenderer {
        let renderer = MKCircleRenderer(circle: self)
        renderer.lineWidth = 5.0
        renderer.strokeColor = .red
        renderer.alpha = 0.5
        return renderer
    }

    convenience init(area: LocationArea) {
        self.init(center: area.location.coordinates(),
                  radius: area.radius)

        var hasher = Hasher()
        hasher.combine(area.radius)
        hasher.combine(area.location.longitude)
        hasher.combine(area.location.latitude)
        self.id = hasher.finalize()
    }
}

private extension Bike {
    func pointAnnotation() -> PointAnnotation? {
        guard let location else { return nil }
        return PointAnnotation(id: id, coordinate: location.coordinates())
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapView(store: .init(initialState: .init(),
                                 reducer: BikeMap()))
    }
}
