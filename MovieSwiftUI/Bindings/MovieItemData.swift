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
    
    func loadMovie() {
        movieService.fetchMovie(id: movie.id, successHandler: {[weak self] (movie) in
            self?.movie = movie
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    

    
    var movie: Movie {
        didSet {
            didChange.send(self)
        }
    }
    
}
