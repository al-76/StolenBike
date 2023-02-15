//
//  App.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 18.01.2023.
//

import ComposableArchitecture

struct App: ReducerProtocol {
    enum Tab {
        case bikeMap
        case registerBike
    }

    struct State: Equatable {
        var tab: Tab = .bikeMap

        var bikeMap: BikeMap.State = .init()
        var registerBike: RegisterBike.State = .init()
    }

    enum Action: Equatable {
        case selectTab(Tab)

        case bikeMap(BikeMap.Action)
        case registerBike(RegisterBike.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.bikeMap, action: /Action.bikeMap) {
            BikeMap()
        }

        Scope(state: \.registerBike, action: /Action.registerBike) {
            RegisterBike()
        }

        Reduce { state, action in
            if case .selectTab(let tab) = action {
                state.tab = tab
            }

            return .none
        }
    }
}
