//
//  StateError.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

struct StateError: Equatable {
    let error: Error

    var description: String {
        error.localizedDescription
    }

    static func == (lhs: StateError, rhs: StateError) -> Bool {
        type(of: lhs.error) == type(of: rhs.error) &&
        lhs.error.localizedDescription == rhs.error.localizedDescription
    }
}
