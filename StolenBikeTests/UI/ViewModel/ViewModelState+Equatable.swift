//
//  ViewModelState+Equatable.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 05.10.2022.
//

import Foundation

@testable import StolenBike

extension ViewModelState: Equatable where T: Equatable {
    public static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.failure(errorA as NSError),
                  .failure(errorB as NSError)):
            return errorA == errorB
        case let (.success(a), .success(b)):
            return a == b
        default:
            return false
        }
    }
}
