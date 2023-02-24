//
//  View+mapElement.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 12.02.2023.
//

import SwiftUI

struct MapElement: ViewModifier {
    let opacity: Double

    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .opacity(opacity)
            .cornerRadius(8)
    }
}

extension View {
    func mapElement(opacity: Double = 0.9) -> some View {
        modifier(MapElement(opacity: opacity))
    }
}
