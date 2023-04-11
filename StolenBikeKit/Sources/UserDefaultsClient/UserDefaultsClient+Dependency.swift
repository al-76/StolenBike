//
//  UserDefaultsClient+Dependency.swift
//  
//
//  Created by Vyacheslav Konopkin on 08.04.2023.
//

import ComposableArchitecture

extension UserDefaultsClient: DependencyKey {
    public static var liveValue = UserDefaultsClient.live
    public static var previewValue = UserDefaultsClient.preview
    public static var testValue = UserDefaultsClient.test
}

extension DependencyValues {
    public var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
