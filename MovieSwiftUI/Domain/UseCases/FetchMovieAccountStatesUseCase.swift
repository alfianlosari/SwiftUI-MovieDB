//
//  FetchMovieAccountStatesUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Fetch Movie Account States Use Case

protocol FetchMovieAccountStatesUseCase: Sendable {

    func execute(
        movieID: Int,
        sessionID: String
    ) async throws -> MovieAccountStates
}

// MARK: - Default Implementation

struct DefaultFetchMovieAccountStatesUseCase:
    FetchMovieAccountStatesUseCase {

    // MARK: - Dependencies

    private let repository: any AccountRepository

    // MARK: - Initialization

    init(repository: any AccountRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute(
        movieID: Int,
        sessionID: String
    ) async throws -> MovieAccountStates {

        try await repository.fetchMovieAccountStates(
            movieID: movieID,
            sessionID: sessionID
        )
    }
}

