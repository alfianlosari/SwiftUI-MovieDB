//
//  MovieItemData.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 06/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import Combine

final class MovieItemData: BindableObject {
    
    let didChange = PassthroughSubject<MovieItemData, Never>()
    private let movieService: MovieService
    
    init(movieService: MovieService, movie: Movie) {
        self.movieService = movieService
        self.movie = movie
    }

    var currentRequest: Subscribers.Sink<Movie, Error>?
    
    func loadMovie() {
        currentRequest?.cancel()
        currentRequest = movieService.fetchMovie(id: movie.id).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { [weak self] movie in
            self?.movie = movie
        })
    }

    var movie: Movie {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }

        }
    }
}
