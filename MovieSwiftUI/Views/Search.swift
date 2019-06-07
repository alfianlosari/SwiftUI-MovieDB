//
//  Search.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 07/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct Search: View {
    
    @EnvironmentObject private var movieSearchData: MovieSearchData
    @EnvironmentObject private var keyboardData: KeyboardData
    
    var emptyResultsText: String? {
        if let emptyText = self.movieSearchData.emptyResultQuery {
            return "No results found for \(emptyText)"
        }
        
        return nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                SearchList()
                
                if movieSearchData.isSearching {
                    ActivityIndicatorView()
                }
                
                if movieSearchData.error != nil {
                    MessageText(text: movieSearchData.error!)
                    
                }
                
                if self.emptyResultsText != nil {
                    MessageText(text: self.emptyResultsText!)
                }
                
                }
                
                .navigationBarTitle(Text("Search"))
            }
            .onDisappear(perform: {
                self.movieSearchData.emptyResultQuery = nil
                self.movieSearchData.movies = []
                self.movieSearchData.isSearching = false
            })
            
            .tabItemLabel(Text("Search"))
    }
}

struct SearchList: View {
    
    @State var text = ""
    @EnvironmentObject private var movieSearchData: MovieSearchData
    @EnvironmentObject private var keyboardData: KeyboardData
    
    var body: some View {
        VStack {
            List {
                TextField($text, placeholder: Text("Search your favorite movie"), onEditingChanged: { (_) in
                }) {
                    self.keyboardData.dismissKeyboard()
                    self.movieSearchData.searchMovies(query: self.text)
                    }
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.secondary)
                    .padding()
                    .listRowInsets(EdgeInsets())
                
                
                ForEach(movieSearchData.movies) { movie in
                    NavigationButton(destination: MovieDetail(movieData: MovieItemData(movieService: MovieStore.shared, movie: movie))) {
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .color(.primary)
                                .font(.headline)
                            
                            Text(movie.yearText)
                                .color(.secondary)
                                .font(.subheadline)
                            
                        }
                    }
                }
            }
            
            if (self.keyboardData.height != nil) {
                Rectangle()
                    .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0))
                    .frame(height: self.keyboardData.height!)
                
            }
        }
    }
}

#if DEBUG
struct Search_Previews : PreviewProvider {
    static var previews: some View {
        Search()
            .environmentObject(MovieSearchData(movieService: MovieStore.shared))
    }
}
#endif
