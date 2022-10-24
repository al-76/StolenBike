//
//  GetPlaces.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 03.10.2022.
//

import Foundation
import Combine

final class GetPlacesUseCase: UseCase {
    private let repository: PlacesRepository

    init(repository: PlacesRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: (LocationArea, Int)) -> AnyPublisher<[Place], Error> {
        repository
            .read(area: input.0, page: input.1)
            .eraseToAnyPublisher()
    }
}
