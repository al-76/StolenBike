//
//  StateError.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

public struct StateError: Equatable {
    public let error: Error

    public var description: String {
        error.localizedDescription
    }

    public init(error: Error) {
        self.error = error
    }

    public static func == (lhs: StateError, rhs: StateError) -> Bool {
        type(of: lhs.error) == type(of: rhs.error) &&
        lhs.error.localizedDescription == rhs.error.localizedDescription
    }
}
