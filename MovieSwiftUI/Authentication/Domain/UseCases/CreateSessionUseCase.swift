//
//  CreateSessionUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 23/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Create Session Use Case

protocol CreateSessionUseCase {
    func execute(requestToken: String) async throws -> String
}

// MARK: - Default Implementation

final class DefaultCreateSessionUseCase:
    CreateSessionUseCase {

    // MARK: - Dependencies

    private let repository: AuthRepository

    // MARK: - Initialization

    init(repository: AuthRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute(
        requestToken: String
    ) async throws -> String {
        try await repository.createSession(
            requestToken: requestToken
        )
    }
}
