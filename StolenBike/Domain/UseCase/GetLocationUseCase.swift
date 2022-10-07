//
//  GetLocationUseCase.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 02.10.2022.
//

import Foundation
import Combine

final class GetLocationUseCase: UseCase {
    private let repository: LocationRepository

    init(repository: LocationRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: Void) -> AnyPublisher<Location, Error> {
        repository.read()
    }
}
