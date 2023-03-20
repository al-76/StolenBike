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

    public struct State: Equatable {
        var region: MKCoordinateRegion?
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

        var settings: BikeMapSettings.State
        var list: BikeMapList.State

        public init(region: MKCoordinateRegion? = nil,
                    isLoading: Bool = false,
                    isOutOfArea: Bool = false,
                    locationError: StateError? = nil,
                    settings: BikeMapSettings.State = .init(),
                    list: BikeMapList.State = .init()) {
            self.region = region
            self.isLoading = isLoading
            self.isOutOfArea = isOutOfArea
            self.locationError = locationError
            self.settings = settings
            self.list = list
        }

        public init(region: MKCoordinateRegion? = nil,
                    area: LocationArea? = nil,
                    bikes: [Bike] = [],
                    isLoading: Bool = false,
                    isOutOfArea: Bool = false,
                    fetchError: StateError? = nil,
                    locationError: StateError? = nil,
                    settings: BikeMapSettings.State = .init()) {
            self.region = region
            self.isLoading = isLoading
            self.isOutOfArea = isOutOfArea
            self.locationError = locationError
            self.settings = settings
            self.list = .init(area: area, bikes: bikes, error: fetchError)
        }
    }

    public enum Action: Equatable {
        case updateRegion(MKCoordinateRegion?)

        case getLocation
        case getLocationResult(TaskResult<Location>)

        case changeArea
        case fetch

        case settings(BikeMapSettings.Action)
        case list(BikeMapList.Action)
    }

    @Dependency(\.locationClient) var locationClient

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.settings, action: /Action.settings) {
            BikeMapSettings()
        }

        Scope(state: \.list, action: /Action.list) {
            BikeMapList()
        }

        Reduce { state, action in
            switch action {
            case let .updateRegion(region):
                guard let region,
                      let area = state.area else {
                    break
                }
                state.region = region
                state.isOutOfArea = CLLocation(region.center).isOutOf(area: area)

            case .getLocation:
                state.locationError = nil
                return .task {
                    await .getLocationResult(TaskResult { @MainActor in
                        try await locationClient.get()
                    })
                }

            case let .getLocationResult(.success(location)):
                if state.region == nil {
                    state.region = MKCoordinateRegion(center: location.coordinates(),
                                                      latitudinalMeters: Self.areaDistance / 2,
                                                      longitudinalMeters: Self.areaDistance / 2)
                } else {
                    state.region?.center = location.coordinates()
                }

                if let area = state.area,
                   !CLLocation(location).isOutOf(area: area) {
                    break // Skip a location in the same area
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
                state.isLoading = true
                return .send(.list(.fetch))

            case .list(.fetchResult):
                state.isLoading = false

            case let .settings(.updateIsGlobalSearch(value)):
                if value {
                    state.area = nil
                    break
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
