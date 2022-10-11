//
//  MapperMock.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 11.10.2022.
//

import Foundation
import Combine

@testable import StolenBike

final class MapperMock<Input, Output>: Mapper {
    init() {}

    private(set) var callMapCount = 0

    var callMapArgValues = [Input]()
    var callMapHandler: ((Input) -> Output)?

    func map(input: Input) -> Output {
        callMapCount += 1
        callMapArgValues.append(input)

        if let callMapHandler {
            return callMapHandler(input)
        }

        fatalError("callMapHandler returns can't have a default value thus its handler must be set")
    }
}
