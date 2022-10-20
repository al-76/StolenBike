//
//  ViewModelState+onSuccess.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 20.10.2022.
//

import SwiftUI

extension ViewModelState {
    @ViewBuilder
    func onSuccess(@ViewBuilder handler: (T) -> some View) -> some View {
        switch self {
        case .loading:
            ProgressView("Loading...")

        case .success(let data):
            handler(data)

        case .failure(let error):
            ErrorView(error: error)
        }
    }
}
