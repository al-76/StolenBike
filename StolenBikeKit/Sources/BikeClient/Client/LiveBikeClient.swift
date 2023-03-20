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

    private static let pageSize = 100

    static var live = Self(fetch: { area, page, query in
        guard let url = getApiUrlSearch(area, page, query) else {
            throw BikeClientError.badUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try fetchDecoder
            .decode(Response.self, from: data)
            .bikes
    }, pageSize: { pageSize })

    static var fetchDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    private static func getApiUrlSearch(_ area: LocationArea?,
                                        _ page: Int,
                                        _ query: String) -> URL? {
        var components = URLComponents(string: "https://bikeindex.org:443/api/v3/search")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(pageSize)"),
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
        case title
        case stolenLocation = "stolen_coordinates"
        case dateStolen = "date_stolen"
        case frameColors = "frame_colors"
        case frameModel = "frame_model"
        case largeImageUrl = "large_img"
        case thumbImageUrl = "thumb"
        case manufacturerName = "manufacturer_name"
        case serial
        case year
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        if let locationValues = try container
            .decodeIfPresent([Double].self, forKey: .stolenLocation),
           locationValues.count >= 2 {
            stolenLocation = Location(latitude: locationValues[0],
                                      longitude: locationValues[1])
        } else {
            stolenLocation = nil
        }

        dateStolen = try container.decodeIfPresent(Date.self, forKey: .dateStolen)
        frameColors = try container.decode([String].self, forKey: .frameColors)
        frameModel = try container.decodeIfPresent(String.self, forKey: .frameModel)
        largeImageUrl = try container.decodeIfPresent(URL.self, forKey: .largeImageUrl)
        thumbImageUrl = try container.decodeIfPresent(URL.self, forKey: .thumbImageUrl)
        manufacturerName = try container.decode(String.self, forKey: .manufacturerName)
        serial = try container.decode(String.self, forKey: .serial)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
    }
}
