//
//  StubUserDefaults.swift
//  
//
//  Created by Vyacheslav Konopkin on 08.04.2023.
//

import XCTestDynamicOverlay

// MARK: - Preview
extension UserDefaultsClient {
    static var preview = Self(bool: { _ in false },
                              data: { _ in nil },
                              setBool: { _, _ in },
                              setData: { _, _ in })
}

// MARK: - Test
extension UserDefaultsClient {
    static var test = Self(bool: unimplemented("UserDefaultsClient.bool"),
                           data: unimplemented("UserDefaultsClient.data"),
                           setBool: unimplemented("UserDefaultsClient.setBool"),
                           setData: unimplemented("UserDefaultsClient.setData"))
}
