//
//  MovieListRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol MovieListRepository: Sendable {

    func fetchMovies(
        category: MovieCategory,
        page: Int
    ) async throws -> MoviesPage
}
