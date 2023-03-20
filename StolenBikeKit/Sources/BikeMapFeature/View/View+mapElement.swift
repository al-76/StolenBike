//
//  View+mapElement.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 12.02.2023.
//

import SwiftUI

struct MapElement: ViewModifier {
    let opacity: Double
    let padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.white)
            .opacity(opacity)
            .cornerRadius(8.0)
    }
}

extension View {
    func mapElement(opacity: Double = 0.9,
                    padding: CGFloat = 10.0) -> some View {
        modifier(MapElement(opacity: opacity,
                            padding: padding))
    }
}
