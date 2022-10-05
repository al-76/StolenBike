//
//  UseCaseMock.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 04.10.2022.
//

import Foundation
import Combine

@testable import StolenBike

final class UseCaseMock<Input, Output>: UseCase {
    init() {}

    private(set) var callAsFunctionCallCount = 0

    var callAsFunctionArgValues = [Input]()
    var callAsFunctionHandler: ((Input) -> (AnyPublisher<Output, Error>))?

    func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error> {
        callAsFunctionCallCount += 1
        callAsFunctionArgValues.append(input)

        if let callAsFunctionHandler = callAsFunctionHandler {
            return callAsFunctionHandler(input)
        }

        fatalError("callAsFunctionHandler returns can't have a default value thus its handler must be set")
    }
}

extension UseCaseMock where Input == Void {
    func callAsFunction() -> AnyPublisher<Output, Error> {
        callAsFunction(())
    }
}
