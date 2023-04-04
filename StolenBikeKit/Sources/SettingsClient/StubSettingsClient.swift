//
//  StubSettingsClient.swift
//  
//
//  Created by Vyacheslav Konopkin on 04.04.2023.
//

import XCTestDynamicOverlay

// MARK: - Preview
extension SettingsClient {
    static var preview = Self(open: { })
}

// MARK: - Test
extension SettingsClient {
    static var test = Self(open: unimplemented("SettingsClient.open"))
}
