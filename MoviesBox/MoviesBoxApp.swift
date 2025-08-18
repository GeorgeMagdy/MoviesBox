//
//  MoviesBoxApp.swift
//  MoviesBox
//
//  Created by George Magdy on 15/08/2025.
//

import SwiftUI
import Caching
import Networking
import MovieModels

@main
struct MoviesBoxApp: App {
    var body: some Scene {
        WindowGroup {
            MovieHomeView(viewModel: MovieListViewModel(networkManager: NetworkingManager(), cachingManager: CachingHandler()))
        }
    }
}
