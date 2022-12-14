@testable import StolenBike///
/// @Generated by Mockolo
///



import Combine
import Foundation


class NetworkMock: Network {
    init() { }


    private(set) var requestCallCount = 0
    var requestHandler: ((URL) -> (AnyPublisher<Data, Error>))?
    func request(url: URL) -> AnyPublisher<Data, Error> {
        requestCallCount += 1
        if let requestHandler = requestHandler {
            return requestHandler(url)
        }
        fatalError("requestHandler returns can't have a default value thus its handler must be set")
    }
}

class LocationManagerMock: LocationManager {
    init() { }

     typealias OnGetLocation = (Result<Location, Error>) -> Void

    private(set) var getLocationCallCount = 0
    var getLocationHandler: ((@escaping OnGetLocation) -> ())?
    func getLocation(onGetLocation: @escaping OnGetLocation)  {
        getLocationCallCount += 1
        if let getLocationHandler = getLocationHandler {
            getLocationHandler(onGetLocation)
        }
        
    }
}

class PlacesRepositoryMock: PlacesRepository {
    init() { }


    private(set) var readCallCount = 0
    var readHandler: ((LocationArea, Int) -> (AnyPublisher<[Place], Error>))?
    func read(area: LocationArea, page: Int) -> AnyPublisher<[Place], Error> {
        readCallCount += 1
        if let readHandler = readHandler {
            return readHandler(area, page)
        }
        fatalError("readHandler returns can't have a default value thus its handler must be set")
    }
}

class LocationRepositoryMock: LocationRepository {
    init() { }


    private(set) var readCallCount = 0
    var readHandler: (() -> (AnyPublisher<Location, Error>))?
    func read() -> AnyPublisher<Location, Error> {
        readCallCount += 1
        if let readHandler = readHandler {
            return readHandler()
        }
        fatalError("readHandler returns can't have a default value thus its handler must be set")
    }
}

