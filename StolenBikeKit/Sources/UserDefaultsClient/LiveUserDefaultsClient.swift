//
//  LiveUserDefaultsClient.swift
//  
//
//  Created by Vyacheslav Konopkin on 08.04.2023.
//

import Foundation

extension UserDefaultsClient {
    static var live: Self {
        let userDefaults = { UserDefaults(suiteName: "group.stolenbike")! }
        return Self(
            bool: { userDefaults().bool(forKey: $0) },
            data: { userDefaults().data(forKey: $0) },
            setBool: { userDefaults().set($1, forKey: $0) },
            setData: { userDefaults().set($1, forKey: $0) }
        )
    }
}
