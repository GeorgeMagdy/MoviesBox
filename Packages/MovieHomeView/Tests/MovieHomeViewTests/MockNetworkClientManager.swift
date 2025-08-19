//
//  File.swift
//  MovieHomeView
//
//  Created by George Magdy on 19/08/2025.
//

import Foundation
import Networking
import Combine
import MovieModels

@testable import MovieHomeView

final class MockNetworkManager: NetworkingClientProtocol, Mocable {
    func fetch<T>(withNetWorkURLHelper netWorkURLHelper: Networking.NetworkURLAPIHelper) -> AnyPublisher<T, Networking.NCError> where T : Decodable {
        
        var response: T!
        if T.self == GenreResponse.self {
            print("MovieGenreResponse")
            response = loadJson("MovieGenreResponse", type: T.self)
        }else if T.self == MovieResponse.self {
            print("MovieGenreMoivesListResponse")
            response = loadJson("MovieGenreMoivesListResponse", type: T.self)
        }
        return Just(response)
            .setFailureType(to: Networking.NCError.self).eraseToAnyPublisher()
    }
}
