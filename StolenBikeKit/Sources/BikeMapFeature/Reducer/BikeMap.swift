//
//  BikeMap.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 09.02.2023.
//

import ComposableArchitecture
import CoreLocation
import MapKit

import BikeClient
import LocationClient
import SharedModel
import Utils

public struct BikeMap: ReducerProtocol {
    static let areaDistance = 10_000.0
    static let maxPages = 5

    public struct State: Equatable {
        var region: MKCoordinateRegion?
        var area: LocationArea?
        var bikes: [Bike]
        var page: Int
        var isLoading: Bool
        var isOutOfArea: Bool
        var query: String
        var fetchCount: Int
        var fetchError: StateError?
        var locationError: StateError?

        var settings: BikeMapSettings.State

        public init(region: MKCoordinateRegion? = nil,
                    area: LocationArea? = nil,
                    bikes: [Bike] = [],
                    page: Int = 1,
                    isLoading: Bool = false,
                    isOutOfArea: Bool = false,
                    query: String = "",
                    fetchError: StateError? = nil,
                    locationError: StateError? = nil,
                    fetchCount: Int = 0,
                    settings: BikeMapSettings.State = .init()) {
            self.region = region
            self.area = area
            self.bikes = bikes
            self.page = page
            self.isLoading = isLoading
            self.isOutOfArea = isOutOfArea
            self.query = query
            self.fetchError = fetchError
            self.locationError = locationError
            self.fetchCount = fetchCount
            self.settings = settings
        }
    }

    public enum Action: Equatable {
        case updateRegion(MKCoordinateRegion?)
        case updateQuery(String)

        case getLocation
        case getLocationResult(TaskResult<Location>)

        case changeArea

        case fetch
        case fetchMore
        case fetchResult(TaskResult<[Bike]>)

        case fetchCount
        case fetchCountResult(Int)

        case settings(BikeMapSettings.Action)
    }

    @Dependency(\.locationClient) var locationClient
    @Dependency(\.bikeClient) var bikeClient

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.settings, action: /Action.settings) {
            BikeMapSettings()
        }

        Reduce { state, action in
            switch action {
            case let .updateRegion(region):
                guard let region, let area = state.area else { break }

                state.region = region
                state.isOutOfArea = CLLocation(region.center).isOutOf(area: area)

            case let .updateQuery(query):
                state.query = query

            case .getLocation:
                state.locationError = nil
                return .run { send in
                    for try await location in locationClient.get() {
                        await send(.getLocationResult(.success(location)))
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
                state.bikes = []
                state.isOutOfArea = false
                return reduceFetch(state: &state)

            case .fetchMore:
                return reduceFetch(state: &state, pageIncrement: 1)

            case let .fetchResult(.success(bikes)):
                state.isLoading = false
                guard state.bikes.last != bikes.last,
                      !bikes.isEmpty,
                      state.page < Self.maxPages else {
                    return .send(.fetchCount)
                }

                state.bikes += bikes
                state.isLoading = true
                return .send(.fetchMore)

            case let .fetchResult(.failure(error)):
                state.isLoading = false
                state.page = max(1, state.page - 1)
                state.fetchError = StateError(error: error)

            case .fetchCount:
                state.isLoading = true
                return .task { [area = state.area,
                                query = state.query] in
                    .fetchCountResult(try await bikeClient.fetchCount(area, query))
                } catch: { error in
                    print(".fetchCount error: \(error)")
                    return .fetchCountResult(0)
                }

            case let .fetchCountResult(count):
                state.isLoading = false
                state.fetchCount = count

            case let .settings(.updateIsGlobalSearch(value)):
                if value {
                    state.area = nil
                } else {
                    return .task { .getLocation }
                }
            }

            return .none
        }
    }

    private func reduceFetch(state: inout State, pageIncrement: Int = 0) -> EffectTask<Action> {
        let page = (pageIncrement == 0 ? 1 : state.page + 1)

        state.isLoading = true
        state.page = page
        state.fetchError = nil

        return .task { [area = state.area,
                        page = state.page,
                        query = state.query] in
            await .fetchResult(TaskResult {
                try await bikeClient.fetch(area, page, query)
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
        distance(from: CLLocation(area.location)) > area.radius
    }
}
