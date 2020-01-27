//
//  MovieSearchData.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 07/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import Combine

final class MovieSearchData: ObservableObject {
    
    private let movieService: MovieService
    @Published var error: String? = nil
    @Published var isSearching = false
    @Published var movies: [Movie] = []
    @Published var emptyResultQuery: String? = nil
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func searchMovies(query: String) {
        self.movies = []
        self.error = nil
        self.emptyResultQuery = nil
        guard query.count > 1 else {
            return
        }
                
        self.isSearching = true
        
        movieService.searchMovie(query: query, params: nil, successHandler: { [weak self] (response) in
            self?.isSearching = false
            self?.movies = response.results
            if response.results.isEmpty {
                self?.emptyResultQuery = query
            }
        }) { [weak self] (error) in
            self?.isSearching = false
            self?.error = error.localizedDescription
        }
    }
    
}
