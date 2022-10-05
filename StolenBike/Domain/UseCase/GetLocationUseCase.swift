//
//  GetLocationUseCase.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 02.10.2022.
//

import Foundation
import Combine

final class GetLocationUseCase: UseCase {
    func callAsFunction(_ input: Void) -> AnyPublisher<Location, Error> {
        Just(Location(latitude: 59.3, longitude: 18.07))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
