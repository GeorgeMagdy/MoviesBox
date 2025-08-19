//
//  MovieDetailsViewModel.swift
//  MoviesBox
//
//  Created by George Magdy on 19/08/2025.
//

import Foundation
import MovieModels
import Networking
import Caching
import Combine
import Utilities

public final class MovieDetailsViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var movieDetail: MovieDetail?
    @Published var isLoading: Bool = true
    
    private let movieId: Int
    private let networkManager: NetworkingClientProtocol
    private let cachingManager: CachingHandler
    private var moviesDetails = [Int: MovieDetail]()
    private var cancellables: Set<AnyCancellable> = []
    
    public init(networkManager: NetworkingClientProtocol, cachingManager: CachingHandler, movieId: Int) {
        self.networkManager = networkManager
        self.cachingManager = cachingManager
        self.movieId = movieId
        $alertItem.sink { [weak self] alertItem in
            guard let self = self, alertItem != nil  else { return }
            isLoading = false
        }.store(in: &cancellables)
        loadMovieDetails()
    }
}

private extension MovieDetailsViewModel {
    private func loadMovieDetails() {
        let result = cachingManager.loadFromFile([Int: MovieDetail].self, fileName: Constants.StorageKeys.movieDetails)
        switch result {
        case .success(let movieDetailsResponse):
            self.moviesDetails = movieDetailsResponse
            if let movieDetail = movieDetailsResponse[movieId] {
                self.movieDetail = movieDetail
                return
            }
            fetchMovieDetails()
        case .failure(let error):
            if error == CError.fileNotFound {
                fetchMovieDetails()
                return
            }
            print(error)
            self.alertItem = AlertContext.unknown
        }
    }
    
    func fetchMovieDetails() {
        networkManager.fetch(withNetWorkURLHelper: .movieDetails(movieId: "\(movieId)"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.alertItem = AlertContext.unableToComplete
                }
            } receiveValue: { [weak self] (response: MovieDetail) in
                guard let self = self else { return }
                self.moviesDetails[movieId] = response
                
                self.movieDetail = response
                self.cachingManager.saveToFile(self.moviesDetails, fileName: Constants.StorageKeys.movieDetails)
            }.store(in: &cancellables)
    }
}
