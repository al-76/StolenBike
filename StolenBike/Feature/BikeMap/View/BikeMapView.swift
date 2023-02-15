//
//  BikeMapView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import ComposableArchitecture
import SwiftUI
import MapKit
import CoreLocationUI

struct BikeMapView: View {
    let store: StoreOf<BikeMap>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                MapView(region: viewStore.binding(get: \.region,
                                                  send: { .updateRegion($0) }),
                        annotations: viewStore.bikes.compactMap { $0.pointAnnotation() },
                        overlays: mapOverlays(viewStore.area))
                .edgesIgnoringSafeArea(.top)

                VStack {
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
                    LocationButton {
                        viewStore.send(.getLocation)
                    }
                    .symbolVariant(.fill)
                    .cornerRadius(8.0)
                    .foregroundColor(.white)
                    .padding()
                }
            }
            .alert(error: viewStore.locationError) {
                viewStore.send(.getLocation)
            }
            .alert(error: viewStore.fetchError) {
                viewStore.send(.fetch)
            }
            .onAppear {
                viewStore.send(.getLocation)
            }
            .onChange(of: viewStore.area) { _ in
                viewStore.send(.fetch)
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
                  radius: area.distance)
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
