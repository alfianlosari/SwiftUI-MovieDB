//
//  CreateRequestTokenUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 23/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Create Request Token Use Case

protocol CreateRequestTokenUseCase {
    func execute() async throws -> String
}

// MARK: - Default Implementation

final class DefaultCreateRequestTokenUseCase:
    CreateRequestTokenUseCase {

    // MARK: - Dependencies

    private let repository: AuthRepository

    // MARK: - Initialization

    init(repository: AuthRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute() async throws -> String {
        try await repository.createRequestToken()
    }
}

