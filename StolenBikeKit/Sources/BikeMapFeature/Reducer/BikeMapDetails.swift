//
//  BikeMapDetails.swift
//  
//
//  Created by Vyacheslav Konopkin on 24.03.2023.
//

import ComposableArchitecture
import Foundation

import BikeClient
import Utils

public struct BikeMapDetails: ReducerProtocol {
    public struct State: Equatable {
        var details: BikeDetailsResult

        public init(details: BikeDetailsResult = .loading) {
            self.details = details
        }
    }

    public enum Action: Equatable {
        case fetch(Int)
        case fetchResult(TaskResult<BikeDetails>)
    }

    public enum BikeDetailsResult: Equatable {
        case loading
        case failure(StateError)
        case success(BikeDetails)
    }

    @Dependency(\.bikeClient) var bikeClient

    public init() {}

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .fetch(id):
            state.details = .loading
            return .task {
                await .fetchResult(TaskResult {
                    try await bikeClient.fetchDetails(id)
                })
            }

        case let .fetchResult(.success(bikeDetails)):
            state.details = .success(bikeDetails)

        case let .fetchResult(.failure(error)):
            state.details = .failure(StateError(error: error))
        }

        return .none
    }
}
