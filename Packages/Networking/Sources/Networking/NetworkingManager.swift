//
//  NetworkingManager.swift
//  Networking
//
//  Created by George Magdy on 16/08/2025.
//

import Foundation
import SwiftUI
import Combine
import MovieModels

public class NetworkingManager: NetworkingClientProtocol {
    
    public init() {}
        
    private func addDefaultHeaders(url: URL, method: String = "GET") -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(BaseConstantURL.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    public func fetch<T: Decodable>(withNetWorkURLHelper netWorkURLHelper: NetworkURLAPIHelper) -> AnyPublisher<T, NCError> {
        
        guard let uRL = URL(string: netWorkURLHelper.apiFullURL) else {
            return Fail(error: NCError.invalidURL).eraseToAnyPublisher()
        }
        
        let request = addDefaultHeaders(url: uRL)
        
        return  URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw NCError.invalidResponse
                }
                do {
                    return try JSONDecoder().decode(T.self, from: output.data)
                } catch {
                    throw NCError.invalidData
                }
            }.mapError({ error in
                if let apError = error as? NCError {
                    return apError
                } else {
                    return NCError.unknown
                }
            }).eraseToAnyPublisher()
    }
}
