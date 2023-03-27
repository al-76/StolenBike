//
//  View+cornerRadius.swift
//  
//
//  Created by Vyacheslav Konopkin on 26.03.2023.
//

import SwiftUI

extension View {
    @inlinable public func cornerRadius() -> some View {
        cornerRadius(ViewStyle.cornerRadius)
    }
}
