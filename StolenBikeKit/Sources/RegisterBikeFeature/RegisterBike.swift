//
//  RegisterBike.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 09.02.2023.
//

import ComposableArchitecture
import Foundation

public struct RegisterBike: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {
    }

    public init() {}

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        .none
    }
}
