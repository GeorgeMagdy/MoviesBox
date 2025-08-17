//
//  Genre.swift
//  Models
//
//  Created by George Magdy on 15/08/2025.
//

import Foundation

public struct GenreResponse: Codable, Equatable, Sendable {
    public let genres: [Genre]
    
    public init(genres: [Genre]) {
        self.genres = genres
    }
}

public struct Genre: Codable, Equatable, Sendable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

