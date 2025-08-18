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

struct MovieHomeView: View {
//    @State private var selectedGenre: Int = 0
    @State private var searchText: String = ""
    @State private var selectedMovie: Int?
    @ObservedObject private var viewModel: MovieListViewModel
    
    var searchResult: [Movie] {
        return viewModel.searchMovie(for: searchText)
    }
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemYellow]
    }
    
    var body: some View {
        NavigationStack {
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
                        . padding(10)
                    
                    MovieListView(movies: searchResult, selectedMovie: $selectedMovie)
                    
                    Spacer()
                }.padding(10)
            }
            .toolbar{}
            //.navigationTitle("Watch new Movies")
            .searchable(text: $searchText, prompt: "search")
        }
        .onAppear {
            UISearchTextField.appearance().backgroundColor = UIColor.secondarySystemBackground
        }
    }
}

#Preview {
    MovieHomeView(viewModel: MovieListViewModel(networkManager: NetworkingManager(), cachingManager: CachingHandler()))
}

struct MovieListView: View {
    let coloums = Array(repeating: GridItem(.flexible()), count: 2)
    let movies: [Movie]
    @Binding var selectedMovie: Int?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: coloums, alignment: .leading, spacing: 10) {
                ForEach(movies, id: \.id) { movie in
                    VStack(alignment: .leading) {
                        //.background(Color.gray)

                        MovieRemoteImage(imageURLString: movie.posterPath, size: 300)
                            .aspectRatio(contentMode: .fit)
                            //.frame(width: 170, height: 250)
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
                    }
                }
            }
        }
    }
}

