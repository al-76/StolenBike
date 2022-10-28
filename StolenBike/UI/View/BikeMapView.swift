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
    @StateObject private var viewModel = UIContainer.getBikeMapViewModel()

    var body: some View {
        Group {
            if !viewModel.isLocationLoaded {
                ProgressView("Loading...")
            } else {
                ZStack {
                    Map(coordinateRegion: $viewModel.region,
                        annotationItems: viewModel.places) { place in
                        MapAnnotation(coordinate: place.location.coordinates()) {
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
                .alert(error: viewModel.error) {
                    viewModel.fetchLocation()
                }
            }
        }
        .onAppear {
            viewModel.fetchLocation()
        }
    }
}

extension Location {
    func coordinates() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude,
                               longitude: longitude)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapView()
    }
}
