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
import MovieHomeView
import MovieDetailsView

@main
struct MoviesBoxApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var homeVM = MovieListViewModel(networkManager:NetworkingManager(),cachingManager: CachingHandler())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                MovieHomeView(viewModel: homeVM)
                    .onReceive(homeVM.$selectedMovie.compactMap{$0}) { movieID in
                        coordinator.navigateToDetail(id: movieID)
                    }.navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .detail(let id):
                            MovieDetailsView(viewModel: MovieDetailsViewModel(networkManager: NetworkingManager(), cachingManager: CachingHandler(), movieId: id))
                        }
                    }
            }
        }
    }
}
