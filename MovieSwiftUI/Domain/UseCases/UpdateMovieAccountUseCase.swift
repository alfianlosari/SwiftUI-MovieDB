//
//  UpdateMovieAccountUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Update Movie Account Use Case

protocol UpdateMovieAccountUseCase: Sendable {

    func execute(
        movieID: Int,
        action: MovieAccountAction,
        isAdded: Bool,
        sessionID: String
    ) async throws
}

// MARK: - Default Implementation

struct DefaultUpdateMovieAccountUseCase: UpdateMovieAccountUseCase {

    // MARK: - Dependencies

    private let repository: any AccountRepository

    // MARK: - Initialization

    init(repository: any AccountRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute(
        movieID: Int,
        action: MovieAccountAction,
        isAdded: Bool,
        sessionID: String
    ) async throws {

        try await repository.updateMovie(
            movieID: movieID,
            action: action,
            isAdded: isAdded,
            sessionID: sessionID
        )
    }
}

