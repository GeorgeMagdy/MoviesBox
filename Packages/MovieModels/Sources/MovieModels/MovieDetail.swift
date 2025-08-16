//
//  MovieDetail.swift
//  Models
//
//  Created by George Magdy on 16/08/2025.
//

import Foundation

// MARK: - MovieDetail
public struct MovieDetail: Codable {
    public let adult: Bool
    public let backdropPath: String?
    public let belongsToCollection: String?
    public let budget: Int
    public let genres: [Genre]
    public let homepage: String
    public let id: Int
    public let imdbID: String?
    public let originCountry: [String]
    public let originalLanguage: String
    public let originalTitle: String
    public let overview: String
    public let popularity: Double
    public let posterPath: String?
    public let productionCompanies: [ProductionCompany]
    public let productionCountries: [ProductionCountry]
    public let releaseDate: String
    public let revenue: Int
    public let runtime: Int?
    public let spokenLanguages: [SpokenLanguage]
    public let status: String
    public let tagline: String
    public let title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int

    public enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - ProductionCompany
public struct ProductionCompany: Codable {
    public let id: Int
    public let logoPath: String?
    public let name: String
    public let originCountry: String

    public enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
public struct ProductionCountry: Codable {
    public let iso31661: String
    public let name: String

    public enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
public struct SpokenLanguage: Codable {
    public let englishName: String
    public let iso6391: String
    public let name: String

    public enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}

