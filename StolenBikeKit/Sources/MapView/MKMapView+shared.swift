//
//  MKMapView+shared.swift
//  
//
//  Created by Vyacheslav Konopkin on 07.04.2023.
//

import MapKit

extension MKMapView {
    public static let shared: MKMapView = {
        let mapView = MKMapView()
        mapView.showsCompass = false
        mapView.showsScale = true
        mapView.register(MapViewAnnotation.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return mapView
    }()
}
