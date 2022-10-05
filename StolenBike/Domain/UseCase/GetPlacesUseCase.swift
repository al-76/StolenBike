//
//  GetPlaces.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 03.10.2022.
//

import Foundation
import Combine

final class GetPlacesUseCase: UseCase {
    func callAsFunction(_ input: Location) -> AnyPublisher<(Location, [Place]), Error> {
        Just((input,
              [ Place(id: UUID(), location: input) ]))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
