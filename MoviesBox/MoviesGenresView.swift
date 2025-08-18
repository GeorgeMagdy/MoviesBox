//
//  MoviesGenresView.swift
//  MoviesBox
//
//  Created by George Magdy on 18/08/2025.
//

import SwiftUI
import Caching
import Networking
import MovieModels

struct MoviesGenresView: View {
    var genres: [Genre]
    @Binding var selectedGenreID: Int?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(genres, id: \.id) { genre in
                    Button {
                        selectedGenreID = genre.id
                    } label: {
                        ZStack {
                            let base = Capsule()//RoundedRectangle(cornerRadius: 25)
                            base.foregroundColor(selectedGenreID == genre.id ? .yellow : .clear)
                            base.strokeBorder(lineWidth: 2)
                            Text(genre.name)
                                //.font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(selectedGenreID == genre.id ? .black : .white)
                                .minimumScaleFactor(0.5)
                                .padding(5)
                        }
                        .frame(width: 120, height: 40)
                        .foregroundColor(.orange)
                    }
                }
            }
        }
    }
}
