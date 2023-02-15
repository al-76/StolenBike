//
//  RegisterBike.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 09.02.2023.
//

import ComposableArchitecture
import Foundation

struct RegisterBike: ReducerProtocol {
    struct State: Equatable {
    }

    enum Action: Equatable {
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        .none
    }
}
