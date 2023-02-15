//
//  View+mapElement.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 12.02.2023.
//

import SwiftUI

struct MapElement: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .opacity(0.9)
            .cornerRadius(8)
    }
}

extension View {
    func mapElement() -> some View {
        modifier(MapElement())
    }
}
