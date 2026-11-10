//
//  DefaultMovieListRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultMovieListRepository: MovieListRepository {

    // MARK: - Dependencies

    private let client: NetworkClient

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }

    // MARK: - Fetch

    func fetchMovies(
        category: MovieCategory,
        page: Int
    ) async throws -> MoviesPage {

        let response: MoviesPageResponseDTO = try await client.request(
            MovieEndpoint.list(category: category, page: page)
        )

        return response.toDomain()
    }
}
