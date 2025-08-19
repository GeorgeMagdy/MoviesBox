//
//  MovieListView.swift
//  MoviesBox
//
//  Created by George Magdy on 17/08/2025.
//

import SwiftUI
import Caching
import Networking
import MovieModels
import Utilities

public struct MovieHomeView: View {
    @State private var searchText: String = ""
    @ObservedObject private var viewModel: MovieListViewModel
    
    var searchResult: [Movie] {
        return viewModel.searchMovie(for: searchText)
    }
    
    public init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemYellow]
    }
    
    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Text("Watch new Movies")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.yellow)
                    .padding(5)
                
                MoviesGenresView(genres: viewModel.genres, selectedGenreID: $viewModel.selectedGenre)
                    .padding(10)
                
                if viewModel.genreMovies.isEmpty {
                    ProgressView().progressViewStyle(.circular)
                        .padding(.top, 20)
                }else {
                    MovieListView(movies: searchResult, viewModel: viewModel, selectedMovie: $viewModel.selectedMovie)
                }
                
                Spacer()
            }.padding(10)
        }
        .toolbar{}
        .searchable(text: $searchText, prompt: "search")
        .onAppear {
            UISearchTextField.appearance().backgroundColor = UIColor.secondarySystemBackground
        }.alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

#Preview {
    MovieHomeView(viewModel: MovieListViewModel(networkManager: NetworkingManager(), cachingManager: CachingHandler()))
}

struct MovieListView: View {
    let coloums = Array(repeating: GridItem(.flexible()), count: 2)
    let movies: [Movie]
    let viewModel: MovieListViewModel
    @Binding var selectedMovie: Int?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: coloums, alignment: .leading, spacing: 10) {
                ForEach(movies, id: \.id) { movie in
                    VStack(alignment: .leading) {
                        MovieRemoteImage(imageURLString: movie.posterPath, size: 300)
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom, 1)
                        
                        Text(movie.title)
                            .font(.title3)
                            .frame(width: 140, height: 40 , alignment: .leading)
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                            .foregroundColor(.white)
                        
                        Text(movie.releaseYear ?? "")
                            .font(.title)
                            .frame(width: 140, height: 20 , alignment: .leading)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.7)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }.onTapGesture {
                        selectedMovie = movie.id
                    }.onAppear {
                        if let lastElementID = movies.last?.id {
                            if movie.id == lastElementID {
                                switch viewModel.state {
                                case .isLoading:
                                    viewModel.loadMoreMovies()
                                case .loadedAll:
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

