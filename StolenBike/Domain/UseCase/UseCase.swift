//
//  UseCase.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 02.10.2022.
//

import Foundation
import Combine

protocol UseCase<Input, Output> {
    associatedtype Input
    associatedtype Output

    func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error>
}

extension UseCase where Input == Void {
    func callAsFunction() -> AnyPublisher<Output, Error> {
        callAsFunction(())
    }
}
