//
//  BikeMapSettings.swift
//  
//
//  Created by Vyacheslav Konopkin on 25.02.2023.
//

import ComposableArchitecture

public struct BikeMapSettings: ReducerProtocol {
    public struct State: Equatable {
        var isGlobalSearch = false

        public init(isGlobalSearch: Bool = false) {
            self.isGlobalSearch = isGlobalSearch
        }
    }

    public enum Action: Equatable {
        case updateIsGlobalSearch(Bool)
    }

    public init() {}

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .updateIsGlobalSearch(value):
            state.isGlobalSearch = value
        }

        return .none
    }
}
