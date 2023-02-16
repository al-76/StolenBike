//
//  MapViewAnnotation.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 28.10.2022.
//

import Foundation
import MapKit

final class MapViewAnnotation: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        didSet {
            set(with: annotation)
        }
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        set(with: annotation)
    }

    private func set(with annotation: MKAnnotation?) {
        displayPriority = .required

        guard let annotation = annotation as? (any MapViewPointAnnotation) else {
            return
        }

        glyphImage = UIImage(systemName: annotation.glyphImageName)
        clusteringIdentifier = "MapViewClusterAnnotation"
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        transform = CGAffineTransform(translationX: 0, y: -100)
        alpha = 0
        UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.4) {
            self.transform = .identity
            self.alpha = 1
        }.startAnimation()
    }
}
