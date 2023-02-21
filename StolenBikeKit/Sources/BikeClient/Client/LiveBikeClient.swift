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

    static var live = Self(fetch: { area, page in
        guard let url = getApiUrl(area, page) else {
            throw BikeClientError.badUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder()
            .decode(Response.self, from: data)
            .bikes
    })

    private static func getApiUrl(_ area: LocationArea, _ page: Int) -> URL? {
        var components = URLComponents(string: "https://bikeindex.org:443/api/v3/search")
        let distance = max(area.radiusMiles() / 2, 1.0)
        components?.queryItems = [
            URLQueryItem(name: "location", value: "\(area.location.latitude),\(area.location.longitude)"),
            URLQueryItem(name: "distance", value: "\(distance)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "stolenness", value: "proximity")
        ]
        return components?.url
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
