//
//  FetchMoviesUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Use Case

protocol FetchMoviesUseCase: Sendable {

    func execute(
        category: MovieCategory,
        page: Int
    ) async throws -> MoviesPage
}

// MARK: - Default Implementation

struct DefaultFetchMoviesUseCase: FetchMoviesUseCase {

    private let repository: any MovieListRepository

    init(repository: any MovieListRepository) {
        self.repository = repository
    }

    func execute(
        category: MovieCategory,
        page: Int
    ) async throws -> MoviesPage {
        try await repository.fetchMovies(category: category, page: page)
    }
}
