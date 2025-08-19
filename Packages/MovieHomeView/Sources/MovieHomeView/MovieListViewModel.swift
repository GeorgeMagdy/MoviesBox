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
import Utilities

enum state {
    case isLoading
    case loadedAll
}

public final class MovieListViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    @Published var alertItem: AlertItem?
    @Published var selectedGenre: Int?
    @Published var genreMovies: [Movie] = []
    @Published var state: state = .isLoading
    @Published public var selectedMovie: Int?

    
    private let networkManager: NetworkingClientProtocol
    private let cachingManager: CachingHandler
    private var cancellables: Set<AnyCancellable> = []
    private var movieGenreList = [Int: MovieResponse]()
    
    public init(networkManager: NetworkingClientProtocol, cachingManager: CachingHandler) {
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

    
    func loadMoreMovies() {
        if let unwrappedSelectedGenre = selectedGenre {
            let pageNum = getMoviesPageNum(for: unwrappedSelectedGenre)
            fetchGenreMovies(for: unwrappedSelectedGenre, page: pageNum)
        }
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
                loadGenresMoviesList()
                self.selectedGenre = self.genres.first?.id
            case .failure(let error):
                if error == CError.fileNotFound {
                    fetchGenreList()
                    return
                }
                print(error)
                self.alertItem = AlertContext.unknown
            }
        }
    }
    
    private func loadGenresMoviesList() {
        if movieGenreList.isEmpty {
           let result = cachingManager.loadFromFile([Int: MovieResponse].self, fileName: Constants.StorageKeys.genresMoviesList)
            switch result {
            case .success(let movieGenreList):
                self.movieGenreList = movieGenreList
            case .failure(let error):
                print(error)
                if error == CError.fileNotFound {
                    return
                }
                self.alertItem = AlertContext.unknown
            }
        }
    }
    
    private func getMoviesPageNum(for genreId: Int) -> Int {
        var pageNum: Int = 1
        if let movieResponse = movieGenreList[genreId] {
            pageNum = movieResponse.page + 1
            print("George \(pageNum)")
        }
        return pageNum
    }
    
    private func updateMovieList(for genreId: Int, with response: MovieResponse) {
        if let movieResponse = movieGenreList[genreId] {
            let allMovies = movieResponse.results + response.results
            self.movieGenreList[genreId] = MovieResponse(page: response.page, results: allMovies, totalPages: response.totalPages, totalResults: response.totalResults)
            if response.page == response.totalPages {
                self.state = .loadedAll
            }
        }else {
            self.movieGenreList[genreId] = response
        }
        self.genreMovies = self.movieGenreList[genreId]?.results ?? []
    }
}

//MARK: - Network calls
private extension MovieListViewModel {
    func fetchGenreList() {
        networkManager.fetch(withNetWorkURLHelper: .genreList)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.alertItem = AlertContext.unableToComplete
                }
            } receiveValue: { [weak self] (response: GenreResponse) in
                guard let self = self else { return }
                self.genres = response.genres
                self.cachingManager.saveToFile(response, fileName: Constants.StorageKeys.genresList)
                self.selectedGenre = response.genres.first?.id
            }.store(in: &cancellables)
    }
    
    func fetchGenreMovies(for genreId: Int, page: Int = 1) {
        networkManager.fetch(withNetWorkURLHelper: .movieList(page: "\(page)", genreId: "\(genreId)"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.alertItem = AlertContext.unableToComplete
                }
            } receiveValue: { [weak self] (response: MovieResponse) in
                guard let self = self else { return }
                self.updateMovieList(for: genreId, with: response)
                self.cachingManager.saveToFile(self.movieGenreList, fileName: Constants.StorageKeys.genresMoviesList)
            }.store(in: &cancellables)
    }
}
