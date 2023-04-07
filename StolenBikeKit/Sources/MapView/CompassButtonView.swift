//
//  CompassButtonView.swift
//  
//
//  Created by Vyacheslav Konopkin on 07.04.2023.
//

import MapKit
import SwiftUI

public struct CompassButtonView: UIViewRepresentable {
    private let mapView: MKMapView

    public init(mapView: MKMapView = .shared) {
        self.mapView = mapView
    }

    public func makeUIView(context: Context) -> some UIView {
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.setContentHuggingPriority(.required, for: .horizontal)
        compassButton.setContentHuggingPriority(.required, for: .vertical)
        return compassButton
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) { }
}
