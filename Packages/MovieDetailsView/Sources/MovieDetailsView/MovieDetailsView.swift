//
//  MovieDetailsView.swift
//  MoviesBox
//
//  Created by George Magdy on 18/08/2025.
//

import SwiftUI
import MovieModels
import Networking
import Utilities
import Caching

public struct MovieDetailsView: View {
    @ObservedObject private var viewModel: MovieDetailsViewModel
    
    public init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            if let movieDetail = viewModel.movieDetail {
                ScrollView {
                    VStack(alignment: .leading) {
                        MovieRemoteImage(imageURLString: movieDetail.posterPath, size: 300)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 400, height: 350)
                        
                        HStack(alignment: .top) {
                            MovieRemoteImage(imageURLString: movieDetail.posterPath, size: 300)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 90, height: 100)
                            
                            VStack(alignment: .leading) {
                                Text("\(movieDetail.title)  \(movieDetail.releaseDate.year) - \(movieDetail.releaseDate.month)")
                                    .font(.title2)
                                    .frame(alignment: .leading)
                                    .fontWeight(.bold)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.white)
                                
                                Text(movieDetail.movieGenres ?? "")
                                    .font(.title3)
                                    .frame(height: 20 , alignment: .leading)
                                    .fontWeight(.regular)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }.padding(.top, 10)
                        Text(movieDetail.overview)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(5)
                        
                        HStack(alignment: .lastTextBaseline) {
                            Text("Homepage")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Link(movieDetail.homeURLString, destination: movieDetail.homeURL)
                                .font(.callout)
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.8)
                                .lineLimit(1)
                        }.padding(10)
                        
                        itemAndValueView(title: "Languages:", value: movieDetail.spokenLanguageEng)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            itemAndValueView(title: "Status:", value: movieDetail.status)
                            itemAndValueView(title: "Budget:", value: "\(movieDetail.budget)")
                            itemAndValueView(title: "Runtime:", value: "\(movieDetail.runtime ?? 130) minutes")
                            itemAndValueView(title: "Revenue:", value: "\(movieDetail.revenue) $")
                        }.padding(.top, 0)
                    }
                }
            } else {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
        }
        .navigationBarBackButtonHidden(false)
        .toolbarBackground(.hidden, for: .navigationBar)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

#Preview {
    MovieDetailsView(viewModel: MovieDetailsViewModel(networkManager: NetworkingManager(), cachingManager: CachingHandler(), movieId: 19995))
}

struct itemAndValueView: View {
    let title: String
    let value: String
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
                .minimumScaleFactor(0.5)
                .foregroundColor(.white)
            
            Text(value)
                .font(.title3)
                .fontWeight(.regular)
                .minimumScaleFactor(0.5)
                .foregroundColor(.white)
                
        }.padding(.leading, 15)
    }
}
