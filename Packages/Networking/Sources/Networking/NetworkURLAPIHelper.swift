//
//  NetworkURLAPIHelper.swift
//  Networking
//
//  Created by George Magdy on 16/08/2025.
//

import Foundation
import MovieModels

struct BaseConstantURL {
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageURL = "https://image.tmdb.org"
    
    static let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ODViZTczM2JmNjE1NGE3ZDYzNGFmN2Y1ODljMTA0YSIsIm5iZiI6MTc1NTIzNTcxOS41MDMsInN1YiI6IjY4OWVjNTg3ODI5ZmI4OTk0MThlYzcwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7_RfUEdNGw0ylXD3L4E2gi4tqGYZVLe9NEg2rX6eM6E"
    
    //"https://api.themoviedb.org/3/genre/movie/list?language=en"
    
    //"https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=2&sort_by=popularity.desc&with_genres=28"
    
    //https://api.themoviedb.org/3/movie/715253?language=en-US
    
    //https://image.tmdb.org/t/p/w400/1E5baAaEse26fej7uHcjOgEE2t2.jpg
}

public enum NetworkURLAPIHelper {
    case genreList
    case movieList(page: String, genreId: String)
    case movieDetails(movieId: String)
    case image(size: String, imagePath: String)
    
    private var apiPath : String {
        switch self {
        case .genreList:
            return "/genre/movie/list?language=en"
        case .movieList(let page, let genreId):
            return "/discover/movie?include_adult=false&include_video=false&language=en-US&page=\(page)&sort_by=popularity.desc&with_genres=\(genreId)"
        case .movieDetails(let movieId):
            return "/movie/\(movieId)?language=en-US"
        case .image(let size, let imagePath):
            return "/t/p/w\(size)/\(imagePath)"
        }
    }
    
    
    public var apiFullURL : String {
        switch self {
        case .image:
            return BaseConstantURL.imageURL + self.apiPath
        default:
            return BaseConstantURL.baseURL + self.apiPath
        }
    }

    
    //    // MARK: - Response Type
    //    public var responseType: Decodable.Type {
    //        switch self {
    //        case .genreList:
    //            return Genre.self
    //        case .movieList(_):
    //            return MovieResponse.self
    //        case .movieDetails(_, _):
    //            return MovieDetail.self
    //        case .image(_, _):
    //            return Data.self // for image download
    //        }
    //    }

}
