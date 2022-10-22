//
//  View+alert.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 21.10.2022.
//

import Foundation
import SwiftUI

struct ViewError: LocalizedError {
    let error: Error?
    let suggestion: String

    var errorDescription: String? {
        error?.localizedDescription ?? "Unknown error"
    }

    var recoverySuggestion: String? {
        suggestion
    }
}

extension View {
    public func alert(error: Error?, action: (() -> Void)? = nil) -> some View {
        let suggestion = (action == nil ?
                          "Try again later" : "Tap to try again")
        let viewError = ViewError(error: error,
                                  suggestion: suggestion)
        return alert(isPresented: .constant(error != nil),
                     error: viewError) { _ in
            Button("Cancel", role: .cancel) {}
            if let action {
                Button("Try again", action: action)
            }
        } message: { _ in
            Text(suggestion)
        }
    }
}
