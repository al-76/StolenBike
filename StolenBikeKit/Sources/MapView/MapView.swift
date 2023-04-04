//
//  MapView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 28.10.2022.
//

import MapKit
import SwiftUI

public protocol MapViewPointAnnotation: Identifiable, MKPointAnnotation {
    var glyphImageName: String { get }
}

public protocol MapOverlay: Identifiable, MKOverlay {
    var renderer: MKOverlayRenderer { get }
}

public struct MapView<Annotation: MapViewPointAnnotation,
                      Overlay: MapOverlay>: UIViewRepresentable {
    public typealias UIViewType = MKMapView

    fileprivate let region: Binding<MKCoordinateRegion>
    private let annotations: [Annotation]
    private let overlays: [Overlay]
    fileprivate let onSelectedAnnotations: ([Annotation]) -> Void

    public init(region: Binding<MKCoordinateRegion>,
                annotations: [Annotation],
                overlays: [Overlay],
                onSelectedAnnotations: @escaping ([Annotation]) -> Void) {
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
        view.setRegion(region.wrappedValue, animated: true)
    }

    private func updateAnnotations(_ view: MKMapView) {
        updateItems(newItems: annotations,
                    oldItems: view.annotations.compactMap { $0 as? Annotation },
                    onRemoveItems: { view.removeAnnotations($0) },
                    onAddItems: { view.addAnnotations($0) })
    }

    private func updateOverlays(_ view: MKMapView) {
        updateItems(newItems: overlays,
                    oldItems: view.overlays.compactMap { $0 as? Overlay },
                    onRemoveItems: { view.removeOverlays($0) },
                    onAddItems: { view.addOverlays($0) })
    }

    private func updateItems<Item: Identifiable>(newItems: [Item],
                                                 oldItems: [Item],
                                                 onRemoveItems: ([Item]) -> Void,
                                                 onAddItems: ([Item]) -> Void) {
        let oldItemsIds = Set(oldItems.map(\.id))
        let newItemsIds = Set(newItems.map(\.id))
        guard oldItemsIds != newItemsIds else {
            return
        }

        let removeItemsIds = oldItemsIds.subtracting(newItemsIds)
        let addItemsIds = newItemsIds.subtracting(oldItemsIds)

        if !removeItemsIds.isEmpty {
            onRemoveItems(oldItems.filter { removeItemsIds.contains($0.id) })
        }
        if !addItemsIds.isEmpty {
            onAddItems(newItems.filter { addItemsIds.contains($0.id) })
        }
    }

    public func makeCoordinator() -> Coordinator<Annotation, Overlay> {
        Coordinator(mapView: self)
    }
}

public final class Coordinator<Annotation: MapViewPointAnnotation,
                               Overlay: MapOverlay>: NSObject, MKMapViewDelegate {
    private let mapView: MapView<Annotation, Overlay>

    init(mapView: MapView<Annotation, Overlay>) {
        self.mapView = mapView
    }

    public func mapViewDidChangeVisibleRegion(_ mkMapView: MKMapView) {
        mapView.region.wrappedValue = mkMapView.region
    }

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? Overlay else {
            return MKOverlayRenderer()
        }
        return overlay.renderer
    }

    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let cluster = view.annotation as? MKClusterAnnotation,
              let annotations = cluster.memberAnnotations as? [Annotation] else {
            if let annotation = view.annotation as? Annotation {
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
