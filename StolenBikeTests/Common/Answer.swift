//
//  Answer.swift
//  StolenBikeTests
//
//  Created by Vyacheslav Konopkin on 05.10.2022.
//

import XCTest

enum TestError: Error {
    case someError
}

enum Answer {
    static func streamSuccess<T>(_ items: [T]) -> AsyncThrowingStream<T, Error> {
        AsyncThrowingStream { continuation in
            for item in items {
                continuation.yield(item)
            }
            continuation.finish()
        }
    }

    static func streamFailure<T>(_ error: Error = TestError.someError) -> AsyncThrowingStream<T, Error> {
        AsyncThrowingStream {
            $0.finish(throwing: error)
        }
    }
}
