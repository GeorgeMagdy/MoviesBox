//
//  NetworkingClientProtocol.swift
//  Networking
//
//  Created by George Magdy on 16/08/2025.
//

import Foundation
import SwiftUI
import Combine
import MovieModels

public enum NCError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown
}

public protocol NetworkingClientProtocol {
    func fetch<T: Decodable>(withNetWorkURLHelper netWorkURLHelper: NetworkURLAPIHelper) -> AnyPublisher<T, NCError>
}
