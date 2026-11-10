//
//  CreateGuestSessionUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 23/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Create Guest Session Use Case

protocol CreateGuestSessionUseCase {
    func execute() async throws -> GuestSession
}

// MARK: - Default Implementation

final class DefaultCreateGuestSessionUseCase:
    CreateGuestSessionUseCase {

    // MARK: - Dependencies

    private let repository: AuthRepository

    // MARK: - Initialization

    init(repository: AuthRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute() async throws -> GuestSession {
        try await repository.createGuestSession()
    }
}


