//
//  FetchUserListsUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Fetch User Lists Use Case

protocol FetchUserListsUseCase: Sendable {

    func execute(
        sessionID: String
    ) async throws -> [UserList]
}

// MARK: - Default Implementation

struct DefaultFetchUserListsUseCase: FetchUserListsUseCase {

    // MARK: - Dependencies

    private let repository: any AccountRepository

    // MARK: - Initialization

    init(repository: any AccountRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute(
        sessionID: String
    ) async throws -> [UserList] {

        try await repository.fetchUserLists(
            sessionID: sessionID
        )
    }
}

