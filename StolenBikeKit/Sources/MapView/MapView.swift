//
//  MapView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 28.10.2022.
//

import MapKit
import SwiftUI

public protocol MapViewPointAnnotation: Identifiable, Equatable, MKPointAnnotation {
    var id: Int { get }
    var glyphImageName: String { get }
}

public protocol MapOverlay: MKOverlay {
    var renderer: MKOverlayRenderer { get }
}

public struct MapView: UIViewRepresentable {
    public typealias UIViewType = MKMapView

    fileprivate let region: Binding<MKCoordinateRegion?>
    private let annotations: [any MapViewPointAnnotation]
    private let overlays: [any MapOverlay]
    fileprivate let onSelectedAnnotations: ([any MapViewPointAnnotation]) -> Void

    public init(region: Binding<MKCoordinateRegion?>,
                annotations: [any MapViewPointAnnotation],
                overlays: [any MapOverlay],
                onSelectedAnnotations: @escaping ([any MapViewPointAnnotation]) -> Void) {
        self.region = region
        self.annotations = annotations
        self.overlays = overlays
        self.onSelectedAnnotations = onSelectedAnnotations
    }

    public func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(MapViewAnnotation.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return mapView
    }

    public func updateUIView(_ view: MKMapView, context: Context) {
        updateRegion(view)
        updateAnnotations(view)
        updateOverlays(view)
    }

    private func updateRegion(_ view: MKMapView) {
        guard let region = region.wrappedValue else { return }
        view.setRegion(region, animated: true)
    }

    private func updateAnnotations(_ view: MKMapView) {
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

    private func updateOverlays(_ view: MKMapView) {
        let obsoleteOverlays = view.overlays
            .filter { overlay in
                !overlays.contains { overlay.coordinate == $0.coordinate }
            }
        let newOverlays = overlays
            .filter { overlay in
                !view.overlays.contains { overlay.coordinate == $0.coordinate }
            }

        if !obsoleteOverlays.isEmpty {
            view.removeOverlays(obsoleteOverlays)
        }
        if !newOverlays.isEmpty {
            view.addOverlays(newOverlays)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(mapView: self)
    }
}

public final class Coordinator: NSObject, MKMapViewDelegate {
    private let mapView: MapView

    init(mapView: MapView) {
        self.mapView = mapView
    }

    public func mapViewDidChangeVisibleRegion(_ mkMapView: MKMapView) {
        mapView.region.wrappedValue = mkMapView.region
    }

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MapOverlay else {
            return MKOverlayRenderer()
        }
        return overlay.renderer
    }

    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let cluster = view.annotation as? MKClusterAnnotation,
              let annotations = cluster.memberAnnotations as? [any MapViewPointAnnotation] else {
            if let annotation = view.annotation as? (any MapViewPointAnnotation) {
                self.mapView.onSelectedAnnotations([annotation])
            }
            return
        }
        self.mapView.onSelectedAnnotations(annotations)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}
