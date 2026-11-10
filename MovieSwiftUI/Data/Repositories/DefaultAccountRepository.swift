//
//  DefaultAccountRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Account Repository Error

enum AccountRepositoryError: LocalizedError {
    case invalidSession
    case operationFailed(String)
    case missingListID

    var errorDescription: String? {
        switch self {
        case .invalidSession:
            return "Please sign in to your TMDB account."

        case .operationFailed(let message):
            return message

        case .missingListID:
            return "TMDB did not return a list ID."
        }
    }
}

// MARK: - Default Account Repository

final class DefaultAccountRepository: AccountRepository {

    // MARK: - Dependencies

    private let client: NetworkClient

    // MARK: - Initialization

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }

    // MARK: - Account Details

    private func fetchAccountID(
        sessionID: String
    ) async throws -> Int {

        try validateSession(sessionID)

        let response: AccountDetailsResponseDTO =
            try await client.request(
                AccountEndpoint.accountDetails(
                    sessionID: sessionID
                )
            )

        return response.accountID
    }

    // MARK: - Movie Account States

    func fetchMovieAccountStates(
        movieID: Int,
        sessionID: String
    ) async throws -> MovieAccountStates {

        try validateSession(sessionID)

        let response: MovieAccountStatesResponseDTO =
            try await client.request(
                AccountEndpoint.movieAccountStates(
                    movieID: movieID,
                    sessionID: sessionID
                )
            )

        return response.toDomain()
    }

    // MARK: - Update Favorite / Watchlist

    func updateMovie(
        movieID: Int,
        action: MovieAccountAction,
        isAdded: Bool,
        sessionID: String
    ) async throws {

        let accountID = try await fetchAccountID(
            sessionID: sessionID
        )

        let response: AccountStatusResponseDTO =
            try await client.request(
                AccountEndpoint.updateMovie(
                    accountID: accountID,
                    movieID: movieID,
                    action: action,
                    isAdded: isAdded,
                    sessionID: sessionID
                )
            )

        try validateStatus(response)
    }

    // MARK: - Fetch User Lists

    func fetchUserLists(
        sessionID: String
    ) async throws -> [UserList] {

        let accountID = try await fetchAccountID(
            sessionID: sessionID
        )

        let response: UserListsResponseDTO =
            try await client.request(
                AccountEndpoint.userLists(
                    accountID: accountID,
                    sessionID: sessionID
                )
            )

        return response.results.map { list in
            UserList(
                id: list.id,
                name: list.name,
                itemCount: list.itemCount
            )
        }
    }

    // MARK: - Create List

    func createList(
        name: String,
        description: String,
        sessionID: String
    ) async throws -> Int {

        try validateSession(sessionID)

        let response: CreateUserListResponseDTO =
            try await client.request(
                AccountEndpoint.createList(
                    name: name,
                    description: description,
                    sessionID: sessionID
                )
            )

        guard [1, 12].contains(response.statusCode) else {
            throw AccountRepositoryError.operationFailed(
                response.statusMessage
            )
        }

        guard let listID = response.listID else {
            throw AccountRepositoryError.missingListID
        }

        return listID
    }

    // MARK: - Add Movie to List

    func addMovieToList(
        movieID: Int,
        listID: Int,
        sessionID: String
    ) async throws {

        try validateSession(sessionID)

        let response: AccountStatusResponseDTO =
            try await client.request(
                AccountEndpoint.addMovie(
                    listID: listID,
                    movieID: movieID,
                    sessionID: sessionID
                )
            )

        try validateStatus(response)
    }

    // MARK: - Remove Movie from List

    func removeMovieFromList(
        movieID: Int,
        listID: Int,
        sessionID: String
    ) async throws {

        try validateSession(sessionID)

        let response: AccountStatusResponseDTO =
            try await client.request(
                AccountEndpoint.removeMovie(
                    listID: listID,
                    movieID: movieID,
                    sessionID: sessionID
                )
            )

        try validateStatus(response)
    }

    // MARK: - Helpers

    private func validateSession(
        _ sessionID: String
    ) throws {
        guard !sessionID
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty else {
            throw AccountRepositoryError.invalidSession
        }
    }

    private func validateStatus(
        _ response: AccountStatusResponseDTO
    ) throws {
        guard response.isSuccessful else {
            throw AccountRepositoryError.operationFailed(
                response.statusMessage
            )
        }
    }
}

// MARK: - User Lists Response DTO

private struct UserListsResponseDTO: Decodable {
    let results: [UserListItemDTO]
}

private struct UserListItemDTO: Decodable {
    let id: Int
    let name: String
    let itemCount: Int
}

// MARK: - Create List Response DTO

private struct CreateUserListResponseDTO: Decodable {
    let statusCode: Int
    let statusMessage: String
    let listID: Int?
}

