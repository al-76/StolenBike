//
//  View+badge.swift
//  
//
//  Created by Vyacheslav Konopkin on 06.03.2023.
//

import SwiftUI

extension View {
    @ViewBuilder
    func badge(count: Int) -> some View {
        if count == 0 {
            self
        } else {
            overlay(alignment: .topTrailing) {
                Text(" \(count) ")
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.footnote)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .fill(.red)
                        .scaleEffect(1.2))
                    .foregroundColor(.white)
            }
        }
    }
}
