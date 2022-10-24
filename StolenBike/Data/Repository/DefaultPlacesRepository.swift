//
//  DefaultPlacesRepository.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 08.10.2022.
//

import Foundation
import Combine

final class DefaultPlacesRepository: PlacesRepository {
    private let network: Network
    private let mapper: any Mapper<PlaceDTO, Place>

    init(network: Network, mapper: some Mapper<PlaceDTO, Place>) {
        self.network = network
        self.mapper = mapper
    }

    func read(area: LocationArea, page: Int) -> AnyPublisher<[Place], Error> {
        network.request(url: getUrl(with: area, page))
            .decode(type: PlacesDTO.self, decoder: JSONDecoder())
            .map { [weak self] response in
                response.places
                    .filter { $0.location != nil }
                    .compactMap { self?.mapper.map(input: $0) }
            }
            .eraseToAnyPublisher()
    }

    private func getUrl(with area: LocationArea, _ page: Int) -> URL {
        var components = URLComponents(string: "https://bikeindex.org:443/api/v3/search")!
        components.queryItems = [
            URLQueryItem(name: "location", value: "\(area.location.latitude),\(area.location.longitude)"),
            URLQueryItem(name: "distance", value: "\(area.distanceMiles())"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "25"),
            URLQueryItem(name: "stolenness", value: "proximity")
        ]
        return components.url!
    }
}

private extension LocationArea {
    func distanceMiles() -> Double {
        distance / 1609.34
    }
}
