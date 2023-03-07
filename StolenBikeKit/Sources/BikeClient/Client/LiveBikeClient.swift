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

    struct ResponseCount: Decodable {
        let stolen: Int
        let proximity: Int
    }

    static var live = Self(fetch: { area, page, query in
        guard let url = getApiUrlSearch(area, page, query) else {
            throw BikeClientError.badUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder()
            .decode(Response.self, from: data)
            .bikes
    }, fetchCount: { area, query in
        guard let url = getApiUrlSearchCount(area, query) else {
            throw BikeClientError.badUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder()
            .decode(ResponseCount.self, from: data)
        return (area == nil ? response.stolen : response.proximity)
    })

    private static func getApiUrlSearch(_ area: LocationArea?,
                                        _ page: Int,
                                        _ query: String) -> URL? {
        var components = URLComponents(string: "https://bikeindex.org:443/api/v3/search")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "query", value: query)
        ]

        components?
            .queryItems?
            .append(contentsOf: urlQueryItems(with: area))

        print(components?.url)

        return components?.url
    }

    private static func getApiUrlSearchCount(_ area: LocationArea?,
                                             _ query: String) -> URL? {
        var components = URLComponents(string: "https://bikeindex.org:443/api/v3/search/count")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]

        components?
            .queryItems?
            .append(contentsOf: urlQueryItems(with: area))

        print(components?.url)

        return components?.url
    }

    private static func urlQueryItems(with area: LocationArea?) -> [URLQueryItem] {
        guard let area else { return [] }

        let distance = max(area.radiusMiles() / 2, 1.0)
        return [
            URLQueryItem(name: "location", value: "\(area.location.latitude),\(area.location.longitude)"),
            URLQueryItem(name: "distance", value: "\(distance)"),
            URLQueryItem(name: "stolenness", value: "proximity"),
        ]
    }
}

private extension LocationArea {
    func radiusMiles() -> Double {
        radius / 1609.34
    }
}

// MARK: - Bike decoding
extension Bike: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case stolenLocation = "stolen_coordinates"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)

        let locationValues = try container.decode([Double]?.self, forKey: .stolenLocation)
        if let locationValues, locationValues.count >= 2 {
            stolenLocation = Location(latitude: locationValues[0],
                                      longitude: locationValues[1])
        } else {
            stolenLocation = nil
        }
    }
}
