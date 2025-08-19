//
//  MockNetworkManager.swift
//  MovieDetailsView
//
//  Created by George Magdy on 19/08/2025.
//

import Foundation
import Networking
import Combine
import MovieModels

@testable import MovieDetailsView

final class MockNetworkManager: NetworkingClientProtocol, Mocable {
    func fetch<T>(withNetWorkURLHelper netWorkURLHelper: Networking.NetworkURLAPIHelper) -> AnyPublisher<T, Networking.NCError> where T : Decodable {
        let response = loadJson("MovieDetailResponse", type: T.self)
        return Just(response)
            .setFailureType(to: Networking.NCError.self).eraseToAnyPublisher()
    }
}
