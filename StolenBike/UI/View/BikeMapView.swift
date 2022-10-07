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

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading...")

            case .success(let data):
                ZStack {
                    Map(coordinateRegion: .constant(getRegion(from: data.location)),
                        annotationItems: data.places) { place in
                        MapAnnotation(coordinate: place.coordinates()) {
                            Image(systemName: "bicycle.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }

                    VStack {
                        Spacer()
                        LocationButton { viewModel.fetchLocation() }
                            .cornerRadius(30.0)
                            .padding()
                    }
                }

            case .failure(let error):
                ErrorView(error: error)
            }
        }
        .onAppear {
            viewModel.onceFetchLocation()
        }
    }

    private func getRegion(from location: Location) -> MKCoordinateRegion {
        MKCoordinateRegion(center:
                            CLLocationCoordinate2D(latitude: location.latitude,
                                                   longitude: location.longitude),
                           span:
                            MKCoordinateSpan(latitudeDelta: 0.2,
                                             longitudeDelta: 0.2))
    }
}

extension Place {
    func coordinates() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude,
                               longitude: location.longitude)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapView()
    }
}
