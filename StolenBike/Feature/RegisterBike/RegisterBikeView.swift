//
//  RegisterBikeView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 02.10.2022.
//

import ComposableArchitecture
import SwiftUI

struct RegisterBikeView: View {
    let store: StoreOf<RegisterBike>

    var body: some View {
        Text("Register your bike!")
    }
}

struct RegisterBikeView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterBikeView(store: .init(initialState: .init(),
                                      reducer: RegisterBike()))
    }
}
