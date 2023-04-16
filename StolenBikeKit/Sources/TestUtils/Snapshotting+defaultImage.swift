//
//  Snapshotting+defaultImage.swift
//  
//
//  Created by Vyacheslav Konopkin on 16.04.2023.
//

import SnapshotTesting
import SwiftUI

extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    public static var defaultImage: Snapshotting {
        .image(
            perceptualPrecision: 0.98,
            layout: .device(config: .iPhone13Pro)
        )
    }
}
