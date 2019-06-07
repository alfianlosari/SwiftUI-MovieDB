//
//  MovieSearchData.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 07/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import Combine

final class MovieSearchData: BindableObject {
    
    let didChange = PassthroughSubject<MovieSearchData, Never>()
    private let movieService: MovieService
    
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
        }) { (error) in
            self.isSearching = false
            self.error = error.localizedDescription
        }
    }
    
    var error: String? = nil {
        didSet {
            didChange.send(self)
        }
    }
    
    var isSearching = false {
        didSet {
            didChange.send(self)
        }
    }
    
    var movies: [Movie] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    var emptyResultQuery: String? = nil {
        didSet {
            didChange.send(self)
        }
    }
    
}
