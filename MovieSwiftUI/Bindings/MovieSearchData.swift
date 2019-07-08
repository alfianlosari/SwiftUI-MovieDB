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

    private var currentRequest: Subscribers.Sink<MoviesResponse, Error>?
    
    func searchMovies(query: String) {
        self.movies = []
        self.error = nil
        self.emptyResultQuery = nil
        guard !query.isEmpty else { return }
                
        self.isSearching = true
        currentRequest?.cancel()
        currentRequest = movieService.searchMovie(query: SearchQuery(textQuery: query), params: nil).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                self.error = error.localizedDescription
            case .finished:
                break
            }
            self.isSearching = false
        }, receiveValue: { [weak self] response in
            self?.movies = response.results
            if response.results.isEmpty {
                self?.emptyResultQuery = query
            }
        })
    }
    
    var error: String? = nil {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    
    var isSearching = false {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    
    var emptyResultQuery: String? = nil {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
}
