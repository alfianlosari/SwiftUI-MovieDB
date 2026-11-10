//
//  FetchMovieDetailsUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Fetch Movie Details Use Case

protocol FetchMovieDetailsUseCase: Sendable {

    func execute(id: Int) async throws -> MovieDetails
}

// MARK: - Default Implementation

struct DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {

    // MARK: - Dependencies

    private let repository: any MovieDetailsRepository

    // MARK: - Initialization

    init(repository: any MovieDetailsRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute(id: Int) async throws -> MovieDetails {
        try await repository.fetchMovieDetails(id: id)
    }
}
