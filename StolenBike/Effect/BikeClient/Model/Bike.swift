//
//  Bike.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 03.10.2022.
//

struct Bike: Identifiable, Equatable, Decodable {
    let id: Int
    let stolenLocation: Location?
}
