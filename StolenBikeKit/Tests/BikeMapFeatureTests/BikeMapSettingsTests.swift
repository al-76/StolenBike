//
//  BikeMapSettingsTests.swift
//  
//
//  Created by Vyacheslav Konopkin on 06.03.2023.
//

import ComposableArchitecture
import MapKit
import XCTest

import SharedModel
import Utils
import TestUtils

@testable import BikeMapFeature

@MainActor
final class BikeMapSettingsTests: XCTestCase {
    private var store: TestStore<BikeMapSettings.State,
                                 BikeMapSettings.Action,
                                 BikeMapSettings.State,
                                 BikeMapSettings.Action, ()>!

    override func setUp() {
        store = TestStore(initialState: .init(),
                          reducer: BikeMapSettings())
    }

    func testUpdateIsGlobalSearch() async {
        await store.send(.updateIsGlobalSearch(true)) {
            $0.isGlobalSearch = true
        }
    }
}
