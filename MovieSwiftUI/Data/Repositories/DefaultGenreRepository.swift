//
//  DefaultGenreRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Default Genre Repository

final class DefaultGenreRepository: GenreRepository {

    // MARK: - Dependencies

    private let client: NetworkClient

    // MARK: - Initialization

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }

    // MARK: - GenreRepository

    func fetchGenres(for mediaType: MediaType) async throws -> [GenreFilter] {
        let response: GenresResponseDTO = try await client.request(
            GenreEndpoint.list(mediaType: mediaType)
        )
        return response.toDomain()
    }
}
