//
//  RegisterBikeView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 02.10.2022.
//

import ComposableArchitecture
import SwiftUI

public struct RegisterBikeView: View {
    private let store: StoreOf<RegisterBike>

    public init(store: StoreOf<RegisterBike>) {
        self.store = store
    }

    public var body: some View {
        Text("Register your bike!")
    }
}

struct RegisterBikeView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterBikeView(store: .init(initialState: .init(),
                                      reducer: RegisterBike()))
    }
}
