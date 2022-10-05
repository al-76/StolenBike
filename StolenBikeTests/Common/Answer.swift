//
//  Answer.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 05.10.2022.
//

import XCTest
import Combine

func successAnswer<T>(_ data: T) -> AnyPublisher<T, Error> {
    Just(data)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

func failAnswer<T>() -> AnyPublisher<T, Error> {
    failAnswer(TestError.someError, T.self)
}

func failAnswer<T>(_ error: Error, _ type: T.Type) -> AnyPublisher<T, Error> {
    Fail<T, Error>(error: error)
        .eraseToAnyPublisher()
}

func noAnswer<T>() -> AnyPublisher<T, Error> {
    Empty<T, Error>()
        .eraseToAnyPublisher()
}
