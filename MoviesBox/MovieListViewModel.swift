//
//  MovieListViewModel.swift
//  MoviesBox
//
//  Created by George Magdy on 17/08/2025.
//

import Foundation
import MovieModels
import Networking
import Caching

///1- GenreResponse ====> GenreList
///2-MovieResponse ===> related to Genre Type  "string" as dictionary ===> MoviesResponses
///3-MovieDetail ===> related to movieId   "string"  Type as dictionary ===> MoviesDetails


//[String:MovieDetail] ===> 10 Dictionary

final class MovieListViewModel: ObservableObject {
    let networkManager = NetworkingManager()
}
