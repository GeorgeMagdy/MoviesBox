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
import Combine

///1- GenreResponse ====> GenreList
///2-MovieResponse ===> related to Genre Type  "string" as dictionary ===> MoviesResponses
///3-MovieDetail ===> related to movieId   "string"  Type as dictionary ===> MoviesDetails


//[String:MovieDetail] ===> 10 Dictionary



final class MovieListViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    @Published var error: Error?
    @Published var selectedGenre: Int?
    @Published var genreMovies: [Movie] = []

    
    private let networkManager: NetworkingClientProtocol
    private let cachingManager: CachingHandler
    private var cancellables: Set<AnyCancellable> = []
    private var movieGenreList = [Int: MovieResponse]()
    
    init(networkManager: NetworkingClientProtocol, cachingManager: CachingHandler) {
        self.networkManager = networkManager
        self.cachingManager = cachingManager
        loadGenreList()
        $selectedGenre.sink { [weak self] genreId in
            guard let self = self, let genreId = genreId else { return }
            if let movieResponse = movieGenreList[genreId] {
                self.genreMovies = movieResponse.results
                return
            }
            self.fetchGenreMovies(for: genreId)
        }.store(in: &cancellables)
    }

    
    func loadMoreMovies(for genreId: Int) {
        let pageNum = getMoviesPageNum(for: genreId)
        fetchGenreMovies(for: genreId, page: pageNum)
    }
    
    func searchMovie(for query: String) -> [Movie] {
        guard !query.isEmpty else {
            return genreMovies
        }
        return genreMovies.filter { $0.originalTitle.localizedCaseInsensitiveContains(query) ||
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }
}


private extension MovieListViewModel {
    private func loadGenreList() {
        if genres.isEmpty {
           let result = cachingManager.loadFromFile(GenreResponse.self, fileName: Constants.StorageKeys.genresList)
            switch result {
            case .success(let genreResponse):
                self.genres = genreResponse.genres
                self.fetchGenreList()
            case .failure(let error):
                if error == CError.fileNotFound {
                    fetchGenreList()
                    return
                }
                print(error)
                self.error = error
            }
        }
    }
    
    private func loadGenresMoviesList() {
        if movieGenreList.isEmpty {
           let result = cachingManager.loadFromFile([Int: MovieResponse].self, fileName: Constants.StorageKeys.genresList)
            switch result {
            case .success(let movieGenreList):
                self.movieGenreList = movieGenreList
                
            case .failure(let error):
                print(error)
                self.error = error
            }
        }
    }
    
    private func getMoviesPageNum(for genreId: Int) -> Int {
        var pageNum: Int = 1
        if let movieResponse = movieGenreList[genreId] {
            pageNum = movieResponse.page + 1
        }
        return pageNum
    }
    
    private func updateMovieList(for genreId: Int, with response: MovieResponse) {
        if let movieResponse = movieGenreList[genreId] {
            let allMovies = movieResponse.results + response.results
            self.movieGenreList[genreId] = MovieResponse(page: response.page, results: allMovies, totalPages: response.totalPages, totalResults: response.totalResults)
        }else {
            self.movieGenreList[genreId] = response
        }
    }
}

//MARK: - Network calls
private extension MovieListViewModel {
    func fetchGenreList() {
        networkManager.fetch(withNetWorkURLHelper: .genreList)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] (response: GenreResponse) in
                guard let self = self else { return }
                self.genres = response.genres
                //self.cachingManager.saveToFile(response, fileName: Constants.StorageKeys.genresList)
                self.selectedGenre = response.genres.first?.id
            }.store(in: &cancellables)
    }
    
    func fetchGenreMovies(for genreId: Int, page: Int = 1) {
        networkManager.fetch(withNetWorkURLHelper: .movieList(page: "\(page)", genreId: "\(genreId)"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] (response: MovieResponse) in
                guard let self = self else { return }
                self.genreMovies = response.results
                
                self.updateMovieList(for: genreId, with: response)
                
                // self.cachingManager.saveToFile(self.movieGenreList, fileName: Constants.StorageKeys.genresMoviesList)
            }.store(in: &cancellables)
    }
}
