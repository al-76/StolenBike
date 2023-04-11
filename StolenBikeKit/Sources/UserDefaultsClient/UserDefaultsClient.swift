//
//  UserDefaultsClient.swift
//  
//
//  Created by Vyacheslav Konopkin on 08.04.2023.
//

import Foundation

public struct UserDefaultsClient {
    public var bool: (/* key */ String) -> Bool
    public var data: (/* key */ String) -> Data?
    public var setBool: @Sendable (/* key */ String, /* value */ Bool) async -> Void
    public var setData: @Sendable (/* key */ String, /* value */ Data?) async -> Void
}
