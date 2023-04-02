//
//  BikeMapSelection.swift
//  
//
//  Created by Vyacheslav Konopkin on 01.04.2023.
//

import ComposableArchitecture

import BikeClient
import Utils

public struct BikeMapSelection: ReducerProtocol {
    public struct State: Equatable {
        var bikes: [Bike]
        var filteredBikes: [Bike] {
            bikes.filter { filter.isEmpty ||
                $0.title.lowercased().contains(filter.lowercased()) }
        }

        var filter: String

        var details: BikeMapDetails.State

        public init(bikes: [Bike] = [],
                    filter: String = "",
                    details: BikeMapDetails.State = .init()) {
            self.bikes = bikes
            self.filter = filter
            self.details = details
        }
    }

    public enum Action: Equatable {
        case updateFilter(String)

        case details(BikeMapDetails.Action)
    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.details, action: /Action.details) {
            BikeMapDetails()
        }

        Reduce { state, action in
            switch action {
            case let .updateFilter(filter):
                state.filter = filter

            default:
                break
            }

            return .none
        }
    }
}
