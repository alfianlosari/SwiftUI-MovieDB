//
//  DefaultMovieDetailsRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Default Movie Details Repository

final class DefaultMovieDetailsRepository: MovieDetailsRepository {

    // MARK: - Dependencies

    private let client: NetworkClient

    // MARK: - Initialization

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }

    // MARK: - MovieDetailsRepository

    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        let response: MovieDetailsResponseDTO = try await client.request(
            MovieEndpoint.details(id: id)
        )
        return response.toDomain()
    }
}
