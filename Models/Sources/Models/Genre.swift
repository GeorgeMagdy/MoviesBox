//
//  Genre.swift
//  Models
//
//  Created by George Magdy on 15/08/2025.
//

import Foundation

public struct GenreResponse: Codable {
    public let genres: [Genre]
}

public struct Genre: Codable {
    public let id: Int
    public let name: String
}

