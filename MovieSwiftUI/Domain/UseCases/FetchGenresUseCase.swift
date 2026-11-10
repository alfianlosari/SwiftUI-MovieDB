//
//  FetchGenresUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Fetch Genres Use Case

protocol FetchGenresUseCase: Sendable {

    func execute(mediaType: MediaType) async throws -> [GenreFilter]
}

// MARK: - Default Implementation

struct DefaultFetchGenresUseCase: FetchGenresUseCase {

    // MARK: - Dependencies

    private let repository: any GenreRepository

    // MARK: - Initialization

    init(repository: any GenreRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute(mediaType: MediaType) async throws -> [GenreFilter] {
        try await repository.fetchGenres(for: mediaType)
    }
}
