//
//  BikeMapView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 29.09.2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct BikeMapView: View {
    @StateObject private var viewModel = UIContainer.getMapViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.2,
                                                                          longitudeDelta: 0.2))

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading...")

            case .success(let data):
                ZStack {
                    Map(coordinateRegion: $region,
                        annotationItems: data.places) { place in
                        MapAnnotation(coordinate: place.location.coordinates()) {
                            Image(systemName: "bicycle.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    .onReceive(viewModel.$state) { _ in
                        // FIXME: it causes the warning`update within view`
                        region.center = data.location.coordinates()
                    }

                    VStack {
                        Spacer()
                        LocationButton { viewModel.fetchLocation(at: region.area()) }
                            .cornerRadius(30.0)
                            .padding()
                    }
                }

            case .failure(let error):
                ErrorView(error: error)
            }
        }
        .onAppear {
            viewModel.onceFetchLocation(at: region.area())
        }
    }
}

private extension Location {
    func coordinates() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude,
                               longitude: longitude)
    }
}

private extension MKCoordinateRegion {
    func area() -> LocationArea {
        let location1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5,
                                   longitude: center.longitude)
        let location2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5,
                                   longitude: center.longitude)
        let distance = location1.distance(from: location2)
        return LocationArea(location: Location(latitude: center.latitude,
                                               longitude: center.longitude),
                            distance: distance)
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude &&
        lhs.center.longitude == rhs.center.longitude &&
        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
        lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapView()
    }
}
