//
//  StubBike.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 10.02.2023.
//

import SharedModel

extension Bike {
    static let stub = [Bike].stub[0]
}

extension Array where Element == Bike {
    static let stub = [
        Bike(id: 1411331, stolenLocation: Location(latitude: 59.34,
                                             longitude: 18.07)),
        Bike(id: 1355137, stolenLocation: Location(latitude: 59.33,
                                             longitude: 18.07)),
        Bike(id: 1355185, stolenLocation: Location(latitude: 59.33,
                                             longitude: 18.07)),
        Bike(id: 1316596, stolenLocation: Location(latitude: 59.3,
                                             longitude: 18.04)),
        Bike(id: 1241051, stolenLocation: Location(latitude: 59.31,
                                             longitude: 18.03)),
        Bike(id: 1241046, stolenLocation: Location(latitude: 59.31,
                                             longitude: 18.03)),
        Bike(id: 1198475, stolenLocation: Location(latitude: 59.33,
                                             longitude: 18.01)),
        Bike(id: 1241046, stolenLocation: Location(latitude: 59.31,
                                             longitude: 18.03)),
        Bike(id: 1161381, stolenLocation: Location(latitude: 59.32,
                                             longitude: 18.08)),
        Bike(id: 1133487, stolenLocation: Location(latitude: 59.33,
                                             longitude: 18.07)),
        Bike(id: 1110317, stolenLocation: Location(latitude: 59.33,
                                             longitude: 18.07)),
        Bike(id: 937900, stolenLocation: Location(latitude: 59.37,
                                            longitude: 17.98)),
        Bike(id: 933253, stolenLocation: Location(latitude: 59.35,
                                            longitude: 18.07)),
        Bike(id: 919399, stolenLocation: Location(latitude: 59.33,
                                            longitude: 18.05)),
        Bike(id: 866177, stolenLocation: Location(latitude: 59.3,
                                            longitude: 18.12))
    ]
}
