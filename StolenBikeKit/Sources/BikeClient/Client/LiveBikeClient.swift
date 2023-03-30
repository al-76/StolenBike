//
//  LiveBikeClient.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 11.02.2023.
//

import Foundation

import SharedModel

private enum BikeClientError: Error {
    case badUrl
}

extension BikeClient {
    struct Response: Decodable {
        let bikes: [Bike]
    }

    struct ResponseDetails: Decodable {
        let bike: BikeDetails
    }

    private static let pageSize = 100

    static var live = Self(fetch: { area, page, query, stolenness in
        guard let url = getApiUrlSearch(area, page, query, stolenness) else {
            throw BikeClientError.badUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try fetchDecoder
            .decode(Response.self, from: data)
            .bikes
    }, fetchDetails: { id in
        guard let url = getApiUrlDetails(id) else {
            throw BikeClientError.badUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try fetchDecoder
            .decode(ResponseDetails.self, from: data)
            .bike
    }, pageSize: { pageSize })

    static var fetchDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    private static func getApiUrlSearch(_ area: LocationArea?,
                                        _ page: Int,
                                        _ query: String,
                                        _ stolenness: Stolenness) -> URL? {
        var components = URLComponents(string: "https://bikeindex.org:443/api/v3/search")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(pageSize)"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "stolenness", value: stolenness.rawValue)
        ]

        components?
            .queryItems?
            .append(contentsOf: urlQueryItems(with: area))

//        print(components?.url)

        return components?.url
    }

    private static func urlQueryItems(with area: LocationArea?) -> [URLQueryItem] {
        guard let area else { return [] }

        let distance = max(area.radiusMiles() / 2, 1.0)
        return [
            URLQueryItem(name: "location", value: "\(area.location.latitude),\(area.location.longitude)"),
            URLQueryItem(name: "distance", value: "\(distance)")
        ]
    }

    private static func getApiUrlDetails(_ id: Int) -> URL? {
        var components = URLComponents(string: "https://bikeindex.org:443/api/v3/bikes/\(id)")

//        print(components?.url)

        return components?.url
    }
}

private extension LocationArea {
    func radiusMiles() -> Double {
        radius / 1609.34
    }
}
