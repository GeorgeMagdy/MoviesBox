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

class NetworkingManager: NetworkingClientProtocol {
        
    func addDefaultHeaders(url: URL, method: String = "GET") -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(BaseConstantURL.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    func fetch<T: Decodable>(withNetWorkURLHelper netWorkURLHelper: NetworkURLAPIHelper) -> AnyPublisher<T, APError> {
        
        guard let uRL = URL(string: netWorkURLHelper.apiFullURL) else {
            return Fail(error: APError.invalidURL).eraseToAnyPublisher()
        }
        
        let request = addDefaultHeaders(url: uRL)
        
        return  URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw APError.invalidResponse
                }
                do {
                    return try JSONDecoder().decode(T.self, from: output.data)
                } catch {
                    throw APError.invalidData
                }
            }.mapError({ error in
                if let apError = error as? APError {
                    return apError
                } else {
                    return APError.unknown
                }
            }).eraseToAnyPublisher()
    }
    
//    private func handleResponse(data: Data?, response: URLResponse?) throws -> UIImage {
//        guard let response = response as? HTTPURLResponse,
//              response.statusCode >= 200 && response.statusCode < 300 else {
//            throw APError.invalidResponse
//        }
//        
//        guard let data = data,
//              let image = UIImage(data: data) else {
//            throw APError.invalidResponse
//        }
//        
//        return image
//    }
    
//    func downloadImage(withNetWorkURLHelper netWorkURLHelper: NetworkURLAPIHelper) -> AnyPublisher<UIImage, APError> {
//        //KFImage(imageURL)
//        guard let uRL = URL(string: netWorkURLHelper.apiImageFullURL) else {
//            return Fail(error: APError.invalidURL).eraseToAnyPublisher()
//        }
//        
//        let request = addDefaultHeaders(url: uRL)
//        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap(handleResponse)
//            .mapError({ error in
//                if let apError = error as? APError {
//                    return apError
//                } else {
//                    return APError.unknown
//                }
//            }).eraseToAnyPublisher()
//    }
}
