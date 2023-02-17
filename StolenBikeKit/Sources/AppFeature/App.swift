//
//  App.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 18.01.2023.
//

import ComposableArchitecture

import BikeMapFeature
import RegisterBikeFeature

public struct App: ReducerProtocol {
    public enum Tab {
        case bikeMap
        case registerBike
    }

    public struct State: Equatable {
        var tab: Tab

        var bikeMap: BikeMap.State
        var registerBike: RegisterBike.State

        public init(tab: Tab = .bikeMap,
                    bikeMap: BikeMap.State = .init(),
                    registerBike: RegisterBike.State = .init()) {
            self.tab = tab
            self.bikeMap = bikeMap
            self.registerBike = registerBike
        }
    }

    public enum Action: Equatable {
        case selectTab(Tab)

        case bikeMap(BikeMap.Action)
        case registerBike(RegisterBike.Action)
    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
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
