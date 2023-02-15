//
//  MapView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 28.10.2022.
//

import MapKit
import SwiftUI

protocol MapViewPointAnnotation: Identifiable, Equatable, MKPointAnnotation {
    var id: Int { get }
    var glyphImageName: String { get }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    fileprivate let region: Binding<MKCoordinateRegion?>
    private let annotations: [any MapViewPointAnnotation]

    init(region: Binding<MKCoordinateRegion?>,
         annotations: [any MapViewPointAnnotation]) {
        self.region = region
        self.annotations = annotations
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(MapViewAnnotation.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if let region = region.wrappedValue {
            view.setRegion(region, animated: true)
        }

        let oldAnnotations = view.annotations
            .compactMap { $0 as? (any MapViewPointAnnotation) }
        let obsoleteAnnotations = oldAnnotations
            .filter { annotation in
                !annotations.contains { annotation.id == $0.id }
            }
        let newAnnotations = annotations
            .filter { annotation in
                !oldAnnotations.contains { annotation.id == $0.id }
            }

        if !obsoleteAnnotations.isEmpty {
            view.removeAnnotations(obsoleteAnnotations)
        }
        if !newAnnotations.isEmpty {
            view.addAnnotations(newAnnotations)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(mapView: self)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    private let mapView: MapView

    init(mapView: MapView) {
        self.mapView = mapView
    }

    func mapViewDidChangeVisibleRegion(_ mkMapView: MKMapView) {
        mapView.region.wrappedValue = mkMapView.region
    }
}
