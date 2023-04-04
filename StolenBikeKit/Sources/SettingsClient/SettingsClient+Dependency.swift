//
//  SettingsClient+Dependency.swift
//  
//
//  Created by Vyacheslav Konopkin on 04.04.2023.
//

import ComposableArchitecture

extension SettingsClient: DependencyKey {
    public static var liveValue = SettingsClient.live
    public static var previewValue = SettingsClient.preview
    public static var testValue = SettingsClient.test
}

extension DependencyValues {
    public var settingsClient: SettingsClient {
        get { self[SettingsClient.self] }
        set { self[SettingsClient.self] = newValue }
    }
}
