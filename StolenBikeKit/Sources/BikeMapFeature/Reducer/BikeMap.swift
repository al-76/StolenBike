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
import SharedModel
import Utils

public struct BikeMap: ReducerProtocol {
    static let areaDistance = 10_000.0
    public static let defaultRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.334591,
                                                                                        longitude: 18.063240),
                                                         latitudinalMeters: Self.areaDistance / 2,
                                                         longitudinalMeters: Self.areaDistance / 2)

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

        var fetchError: StateError? {
            get { list.error }
            set { list.error = newValue }
        }
        var locationError: StateError?
        var settingsError: StateError?

        var list: BikeMapList.State
        var selection: BikeMapSelection.State

        public init(region: MKCoordinateRegion = BikeMap.defaultRegion,
                    isLoading: Bool = false,
                    isOutOfArea: Bool = false,
                    locationError: StateError? = nil,
                    settingsError: StateError? = nil,
                    list: BikeMapList.State = .init(),
                    selection: BikeMapSelection.State = .init()) {
            self.region = region
            self.isLoading = isLoading
            self.isOutOfArea = isOutOfArea
            self.locationError = locationError
            self.settingsError = settingsError
            self.list = list
            self.selection = selection
        }

        public init(region: MKCoordinateRegion = BikeMap.defaultRegion,
                    area: LocationArea? = nil,
                    bikes: [Bike] = [],
                    isLoading: Bool = false,
                    isOutOfArea: Bool = false,
                    fetchError: StateError? = nil,
                    locationError: StateError? = nil,
                    settingsError: StateError? = nil,
                    selection: BikeMapSelection.State = .init()) {
            self.region = region
            self.isLoading = isLoading
            self.isOutOfArea = isOutOfArea
            self.locationError = locationError
            self.settingsError = settingsError
            self.list = .init(area: area, bikes: bikes, error: fetchError)
            self.selection = selection
        }
    }

    public enum Action: Equatable {
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
            case let .updateRegion(region):
                guard let area = state.area else {
                    break
                }
                state.region = region
                state.isOutOfArea = CLLocation(region.center).isOutOf(area: area)

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

                if let area = state.area,
                   !CLLocation(location).isOutOf(area: area) {
                    break // Skip a location in the same area
                }
                state.area = LocationArea(location: location,
                                          distance: Self.areaDistance)
                return .send(.fetch)

            case let .getLocationResult(.failure(error)):
                state.isLoading = false
                state.locationError = StateError(error: error)
                return .send(.fetch)

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
                return .send(.fetch)

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
