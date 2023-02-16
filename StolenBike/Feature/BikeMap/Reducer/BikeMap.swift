//
//  BikeMap.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 09.02.2023.
//

import ComposableArchitecture
import CoreLocation
import MapKit

import SharedModel
import Utils

struct BikeMap: ReducerProtocol {
    static let areaDistance = 10_000.0
    static let maxPages = 5

    struct State: Equatable {
        var region: MKCoordinateRegion?
        var area: LocationArea?
        var bikes: [Bike] = []
        var page = 1
        var isLoading = false
        var isOutOfArea = false
        var fetchError: StateError?
        var locationError: StateError?
    }

    enum Action: Equatable {
        case updateRegion(MKCoordinateRegion?)

        case getLocation
        case getLocationResult(TaskResult<Location>)

        case changeArea

        case fetch
        case fetchMore
        case fetchResult(TaskResult<[Bike]>)
    }

    @Dependency(\.locationClient) var locationClient
    @Dependency(\.bikeClient) var bikeClient

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .updateRegion(region):
            guard let region, let area = state.area else { break }

            state.region = region
            state.isOutOfArea = CLLocation(region.center).isOutOf(area: area)

        case .getLocation:
            state.locationError = nil
            return .run { @MainActor send in
                for try await location in locationClient.get() {
                    send(.getLocationResult(.success(location)))
                }
            } catch: { error, send in
                await send(.getLocationResult(.failure(error)))
            }

        case let .getLocationResult(.success(location)):
            if state.region == nil {
                state.region = MKCoordinateRegion(center: location.coordinates(),
                                                  latitudinalMeters: Self.areaDistance / 2,
                                                  longitudinalMeters: Self.areaDistance / 2)
            } else {
                state.region?.center = location.coordinates()
            }
            state.area = LocationArea(location: location,
                                      distance: Self.areaDistance)

        case let .getLocationResult(.failure(error)):
            state.locationError = StateError(error: error)

        case .changeArea:
            guard let region = state.region else { break }

            state.area = LocationArea(location: Location(region.center),
                                      distance: Self.areaDistance)

        case .fetch:
            state.isOutOfArea = false
            return reduceFetch(state: &state)

        case .fetchMore:
            return reduceFetch(state: &state, pageIncrement: 1)

        case let .fetchResult(.success(bikes)):
            state.isLoading = false
            guard state.bikes.last != bikes.last,
                  !bikes.isEmpty else {
                break
            }

            state.bikes += bikes
            state.isLoading = true
            return .run { send in
                await send(.fetchMore)
            }

        case let .fetchResult(.failure(error)):
            state.isLoading = false
            state.page = max(1, state.page - 1)
            state.fetchError = StateError(error: error)
        }

        return .none
    }

    private func reduceFetch(state: inout State, pageIncrement: Int = 0) -> EffectTask<Action> {
        let page = (pageIncrement == 0 ? 1 : state.page + 1)
        guard let area = state.area,
              page < Self.maxPages else {
            return .none
        }

        state.isLoading = true
        state.page = page
        state.fetchError = nil

        return .task { [page = state.page] in
            await .fetchResult(TaskResult {
                try await bikeClient.fetch(area, page)
            })
        }
    }
}

private extension CLLocation {
    convenience init(_ location: CLLocationCoordinate2D) {
        self.init(latitude: location.latitude,
                  longitude: location.longitude)
    }

    convenience init(_ location: Location) {
        self.init(latitude: location.latitude,
                  longitude: location.longitude)
    }

    func isOutOf(area: LocationArea) -> Bool {
        distance(from: CLLocation(area.location)) > area.distance
    }
}
