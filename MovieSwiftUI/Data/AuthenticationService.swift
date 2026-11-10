//
//  AuthenticationService.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
 
// MARK: - Errors
 
enum AuthenticationError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case server(statusCode: Int, message: String?)
    case decodingFailed(Error)
    case authenticationFailed
 
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "TMDB API key is missing."
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .server(let statusCode, let message):
            return message ?? "Request failed with status: \(statusCode)"
        case .decodingFailed:
            return "Failed to read the server response."
        case .authenticationFailed:
            return "Authentication failed."
        }
    }
}
 
// MARK: - Response Protocol
 
protocol TMDBSuccessResponse: Decodable {
    var success: Bool { get }
}
 
// MARK: - Authentication Service
 
final class AuthenticationService: Sendable {
 
    // MARK: - Dependencies
 
    private let client: NetworkClient
 
    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }
 
    // MARK: - Public API
 
    func createGuestSessionResponse() async throws -> GuestSessionResponseDTO {
        try await send(.guestSession)
    }
 
    func createGuestSession() async throws -> String {
        try await createGuestSessionResponse().guestSessionId
    }
 
    func createRequestToken() async throws -> String {
        let response: RequestTokenResponseDTO = try await send(.requestToken)
        return response.requestToken
    }
 
    func authorizationURL(
        requestToken: String,
        redirectTo: String? = nil
    ) -> URL? {
        AuthConfiguration.authorizationURL(
            requestToken: requestToken,
            redirectTo: redirectTo
        )
    }
 
    func createSession(requestToken: String) async throws -> String {
        let response: CreateSessionResponseDTO = try await send(
            .createSession(requestToken: requestToken)
        )
        return response.sessionId
    }
 
    // MARK: - Request
 
    private func send<T: TMDBSuccessResponse>(
        _ endpoint: AuthEndpoint
    ) async throws -> T {
 
        let response: T = try await client.request(endpoint)
 
        guard response.success else {
            throw AuthenticationError.authenticationFailed
        }
 
        return response
    }
}
 
