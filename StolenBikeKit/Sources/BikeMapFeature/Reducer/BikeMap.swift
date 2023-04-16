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
import SettingsClient
import UserDefaultsClient
import SharedModel
import Utils

public struct BikeMap: ReducerProtocol {
    static let areaDistance = 10_000.0

    public struct SaveData: Codable, Equatable {
        let region: MKCoordinateRegion
        let area: LocationArea?

        public init(region: MKCoordinateRegion, area: LocationArea?) {
            self.region = region
            self.area = area
        }
    }

    public struct State: Equatable {
        var region: MKCoordinateRegion
        var area: LocationArea? {
            get { list.area }
            set { list.area = newValue }
        }
        var bikes: [Bike] {
            get { list.bikes }
            set { list.bikes = newValue }
        }
        var isLoading: Bool
        var isOutOfArea: Bool
        var isSupressedLocationError: Bool

        var fetchError: StateError? {
            get { list.error }
            set { list.error = newValue }
        }
        var locationError: StateError?
        var settingsError: StateError?

        var list: BikeMapList.State
        var searchMode: BikeMapList.SearchMode {
            list.searchMode
        }
        var selection: BikeMapSelection.State

        public init(region: MKCoordinateRegion = .distant,
                    isLoading: Bool = false,
                    isOutOfArea: Bool = false,
                    isSupressedLocationError: Bool = false,
                    locationError: StateError? = nil,
                    settingsError: StateError? = nil,
                    list: BikeMapList.State = .init(),
                    selection: BikeMapSelection.State = .init()) {
            self.region = region
            self.isLoading = isLoading
            self.isOutOfArea = isOutOfArea
            self.isSupressedLocationError = isSupressedLocationError
            self.locationError = locationError
            self.settingsError = settingsError
            self.list = list
            self.selection = selection
        }

        public init(region: MKCoordinateRegion = .distant,
                    area: LocationArea? = nil,
                    bikes: [Bike] = [],
                    isLoading: Bool = false,
                    isOutOfArea: Bool = false,
                    isSupressedLocationError: Bool = false,
                    fetchError: StateError? = nil,
                    locationError: StateError? = nil,
                    settingsError: StateError? = nil,
                    selection: BikeMapSelection.State = .init()) {
            self.region = region
            self.isLoading = isLoading
            self.isOutOfArea = isOutOfArea
            self.isSupressedLocationError = isSupressedLocationError
            self.locationError = locationError
            self.settingsError = settingsError
            self.list = .init(area: area, bikes: bikes, error: fetchError)
            self.selection = selection
        }
    }

    public enum Action: Equatable {
        case save
        case load
        case loadResult(TaskResult<SaveData>)

        case updateRegion(MKCoordinateRegion)

        case getLocation
        case getLocationResult(TaskResult<Location>)

        case openSettings
        case openSettingsResult(TaskResult<Bool>)

        case changeArea
        case fetch
        case select([Int])

        case fetchErrorCancel
        case locationErrorCancel
        case settingsErrorCancel

        case list(BikeMapList.Action)
        case selection(BikeMapSelection.Action)
    }

    @Dependency(\.locationClient) var locationClient
    @Dependency(\.settingsClient) var settingsClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.list, action: /Action.list) {
            BikeMapList()
        }

        Scope(state: \.selection, action: /Action.selection) {
            BikeMapSelection()
        }

        Reduce { state, action in
            switch action {
            case .load:
                guard let data = userDefaultsClient.data(UserDefaultsClientKey.bikeMapData) else {
                    state.isSupressedLocationError = true
                    return .send(.getLocation)
                }

                return .task {
                    await .loadResult(TaskResult {
                        try JSONDecoder().decode(SaveData.self, from: data)
                    })
                }

            case let .loadResult(.success(data)):
                state.region = data.region
                state.area = data.area
                return .send(.fetch)

            case .save:
                return .fireAndForget { [region = state.region, area = state.area] in
                    try await save(data: SaveData(region: region, area: area))
                }

            case let .updateRegion(region):
                state.region = region
                if let area = state.area {
                    state.isOutOfArea = CLLocation(region.center).isOutOf(area: area)
                }

            case .getLocation:
                state.isLoading = true
                state.locationError = nil
                return .task {
                    await .getLocationResult(TaskResult { @MainActor in
                        try await locationClient.get()
                    })
                }

            case let .getLocationResult(.success(location)):
                state.isLoading = false
                state.region.center = location.coordinates()
                state.region.span = .near
                state.area = LocationArea(location: location,
                                          distance: Self.areaDistance)
                return reduceFetch(state.region, state.area)

            case let .getLocationResult(.failure(error)):
                state.isLoading = false
                if state.isSupressedLocationError {
                    state.isSupressedLocationError = false
                } else {
                    state.locationError = StateError(error: error)
                }

            case .openSettings:
                state.locationError = nil
                state.settingsError = nil
                return .task {
                    await .openSettingsResult(TaskResult {
                        try await settingsClient.open()
                        return true
                    })
                }

            case let .openSettingsResult(.failure(error)):
                state.settingsError = StateError(error: error)

            case .changeArea:
                state.area = LocationArea(location: Location(state.region.center),
                                          distance: Self.areaDistance)
                return reduceFetch(state.region, state.area)

            case .fetch:
                state.isOutOfArea = false
                state.isLoading = true
                return .send(.list(.fetch))

            case let .select(bikesIds):
                state.selection.bikes = bikesIds
                    .map { id in
                        state.bikes.filter { $0.id == id }
                    }
                    .flatMap { $0 }

            case .fetchErrorCancel:
                state.fetchError = nil

            case .locationErrorCancel:
                state.locationError = nil

            case .settingsErrorCancel:
                state.settingsError = nil

            case .list(.fetchResult):
                state.isLoading = false

            case let .list(.updateSearchMode(searchMode)):
                guard searchMode == .localStolen else {
                    state.area = nil
                    return .send(.fetch)
                }
                return .send(.getLocation)

            default:
                break
            }

            return .none
        }
    }

    private func reduceFetch(_ region: MKCoordinateRegion, _ area: LocationArea?) -> EffectTask<Action> {
        .run { send in
            try await save(data: SaveData(region: region, area: area))
            await send(.fetch)
        }
    }

    private func save(data: SaveData) async throws {
        await userDefaultsClient.setData(UserDefaultsClientKey.bikeMapData,
                                         try JSONEncoder().encode(data))
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
