//
//  LiveSettingsClient.swift
//  
//
//  Created by Vyacheslav Konopkin on 04.04.2023.
//

import Foundation
import UIKit

public enum SettingsClientError: Error {
    case urlError
}

extension SettingsClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("Can't create 'openSettingsURLString'", comment: "")
        }
    }
}

extension SettingsClient {
    static var live = Self(
        open: {
            guard let appSettings = await URL(string: UIApplication.openSettingsURLString) else {
                throw SettingsClientError.urlError
            }
            await MainActor.run {
                UIApplication.shared.open(appSettings,
                                          options: [:],
                                          completionHandler: nil)
            }
        }
    )
}
