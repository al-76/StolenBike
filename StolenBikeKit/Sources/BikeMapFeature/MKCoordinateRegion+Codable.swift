//
//  MKCoordinateRegion+Codable.swift
//  
//
//  Created by Vyacheslav Konopkin on 10.04.2023.
//

import MapKit

extension MKCoordinateRegion: Codable {
    enum CodingKeys: String, CodingKey {
        case center
        case span
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let center = try container.decode(CLLocationCoordinate2D.self, forKey: .center)
        let span = try container.decode(MKCoordinateSpan.self, forKey: .span)

        self.init(center: center, span: span)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(center, forKey: .center)
        try container.encode(span, forKey: .span)
    }
}

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)

        self.init(latitude: latitude, longitude: longitude)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

extension MKCoordinateSpan: Codable {
    enum CodingKeys: String, CodingKey {
        case latitudeDelta
        case longitudeDelta
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitudeDelta = try container.decode(CLLocationDegrees.self, forKey: .latitudeDelta)
        let longitudeDelta = try container.decode(CLLocationDegrees.self, forKey: .longitudeDelta)

        self.init(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitudeDelta, forKey: .latitudeDelta)
        try container.encode(longitudeDelta, forKey: .longitudeDelta)
    }
}
