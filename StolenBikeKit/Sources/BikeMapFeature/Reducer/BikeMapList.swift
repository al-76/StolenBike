//
//  BikeMapList.swift
//  
//
//  Created by Vyacheslav Konopkin on 11.03.2023.
//

import ComposableArchitecture

import BikeClient
import SharedModel
import Utils

public struct BikeMapList: ReducerProtocol {
    public enum SearchMode: Equatable {
        case localStolen
        case allStolen
        case allNonStolen
        case all
    }

    public struct State: Equatable {
        var area: LocationArea?

        var query: String {
            get { _query ?? "" }
            set { _query = newValue }
        }
        fileprivate var _query: String?

        var bikes: [Bike]
        var page: Int
        var isLastPage: Bool
        var isLoading: Bool
        var error: StateError?
        var searchMode: SearchMode

        var details: BikeMapDetails.State

        public init(area: LocationArea? = nil,
                    query: String = "",
                    bikes: [Bike] = [],
                    page: Int = 1,
                    isLastPage: Bool = false,
                    isLoading: Bool = false,
                    error: StateError? = nil,
                    searchMode: SearchMode = .localStolen,
                    details: BikeMapDetails.State = .init()) {
            self.area = area
            self._query = query.isEmpty ? nil : query
            self.bikes = bikes
            self.page = page
            self.isLastPage = isLastPage
            self.isLoading = isLoading
            self.error = error
            self.searchMode = searchMode
            self.details = details
        }
    }

    public enum Action: Equatable {
        case updateQuery(String)
        case updateQueryDebounced
        case updateSearchMode(SearchMode)

        case fetch
        case fetchMore(Bike)
        case fetchResult(TaskResult<[Bike]>)

        case details(BikeMapDetails.Action)
    }

    @Dependency(\.bikeClient) var bikeClient

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.details, action: /Action.details) {
            BikeMapDetails()
        }

        Reduce { state, action in
            switch action {
            case let .updateQuery(query):
                state.query = query

            case .updateQueryDebounced:
                guard state._query != nil else {
                    break
                }
                return .send(.fetch)

            case let .updateSearchMode(searchMode):
                state.searchMode = searchMode

            case .fetch:
                state.page = 1
                state.isLastPage = false
                return reduceFetch(&state)

            case let .fetchMore(bike):
                guard !state.isLoading,
                      bike == state.bikes.last,
                      !state.isLastPage else {
                    return .none
                }
                state.page += 1
                return reduceFetch(&state)

            case let .fetchResult(.success(bikes)):
                state.isLoading = false
                if state.page == 1 {
                    state.bikes = []
                }
                state.bikes += bikes
                state.isLastPage = (bikes.count != bikeClient.pageSize())
                state.error = nil

            case let .fetchResult(.failure(error)):
                state.isLoading = false
                state.page = max(1, state.page - 1)
                state.error = StateError(error: error)

            default:
                break
            }

            return .none
        }
    }

    private func reduceFetch(_ state: inout State) -> EffectTask<Action> {
        state.isLoading = true
        state.error = nil

        return .task { [area = state.area,
                        page = state.page,
                        query = state.query,
                        searchMode = state.searchMode] in
            await .fetchResult(TaskResult {
                try await bikeClient.fetch(area,
                                           page,
                                           query,
                                           searchMode.bikeClientStolenness)
            })
        }
    }
}

private extension BikeMapList.SearchMode {
    var bikeClientStolenness: BikeClient.Stolenness {
        switch self {
        case .localStolen:
            return .proximity
        case .allStolen:
            return .stolen
        case .allNonStolen:
            return .non
        case .all:
            return .all
        }
    }
}
