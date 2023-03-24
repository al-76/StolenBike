//
//  StubBike.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import Foundation

import SharedModel

extension Bike {
    public static let stub = [Bike].stub[0]
}

extension Array where Element == Bike {
    public static let stub = [
        Bike(id: 1411331,
             title: "2021 Rad Power Bikes Rad Mini ST (White)",
             stolenCoordinates: [59.34, 18.07],
             dateStolen: Date(timeIntervalSince1970: 1678375053),
             thumb: URL(string: "https://files.bikeindex.org/uploads/Pu/677396/small_20211028_145926.jpg")),
        Bike(id: 1355137,
             title: "Haro Shredder pro",
             stolenCoordinates: [59.33, 18.07],
             dateStolen: nil,
             thumb: nil),
        Bike(id: 1355185,
             title: "lZ3afAiXENGdgrUAo MtVnH2Gw7oZ9k",
             stolenCoordinates: [59.33, 18.07],
             dateStolen: Date(timeIntervalSince1970: 1678381392),
             thumb: nil),
        Bike(id: 1316596,
             title: "Specialized Sectuer",
             stolenCoordinates: [59.3, 18.04],
             dateStolen: Date(timeIntervalSince1970: 1678381392),
             thumb: nil),
        Bike(id: 1241051,
             title: "Trek FX 2 DISC",
             stolenCoordinates: [59.31, 18.03],
             dateStolen: Date(timeIntervalSince1970: 1678381392),
             thumb: URL(string: "https://files.bikeindex.org/uploads/Pu/678067/small_E883D744-BD8B-4E6A-BAE2-2408BEED5372.jpeg")),
        Bike(id: 1241046,
             title: "2016 GT Bicycles Grade FB Comp",
             stolenCoordinates: [59.31, 18.03],
             dateStolen: Date(timeIntervalSince1970: 1678381392),
             thumb: URL(string: "https://files.bikeindex.org/uploads/Pu/676593/small_GT_Grade.png")),
        Bike(id: 1198475,
             title: "2017 Transition Bikes Sentinel",
             stolenCoordinates: [59.33, 18.01],
             dateStolen: Date(timeIntervalSince1970: 1678381392),
             thumb: nil),
        Bike(id: 1241047,
             title: "Turbo commuter e bike Specialized",
             stolenCoordinates: [59.31, 18.03],
             dateStolen: Date(timeIntervalSince1970: 1678381392),
             thumb: URL(string: "https://files.bikeindex.org/uploads/Pu/674815/small_Screenshot_2023-02-16-13-11-22-25_965bbf4d18d205f782c6b8409c5773a4.jpg"))
    ]
}
