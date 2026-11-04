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

// MARK: - Response Models

protocol TMDBSuccessResponse: Decodable {
    var success: Bool { get }
}

struct GuestSessionResponse: TMDBSuccessResponse {
    let success: Bool
    let guestSessionId: String
    let expiresAt: String
}

struct RequestTokenResponse: TMDBSuccessResponse {
    let success: Bool
    let requestToken: String
    let expiresAt: String
}

struct SessionResponse: TMDBSuccessResponse {
    let success: Bool
    let sessionId: String
}

private struct TMDBErrorResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
}

private struct CreateSessionBody: Encodable {
    let requestToken: String
}

// MARK: - Authentication Service

final class AuthenticationService: Sendable {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public API

    func createGuestSessionResponse() async throws -> GuestSessionResponse {
        try await send(.guestSession)
    }

    func createGuestSession() async throws -> String {
        try await createGuestSessionResponse().guestSessionId
    }

    func createRequestToken() async throws -> String {
        let response: RequestTokenResponse = try await send(.requestToken)
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
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let body = try encoder.encode(
            CreateSessionBody(requestToken: requestToken)
        )

        let response: SessionResponse = try await send(
            .createSession,
            body: body
        )
        return response.sessionId
    }

    // MARK: - Request Building

    private func makeRequest(
        endpoint: AuthEndpoint,
        body: Data?
    ) throws -> URLRequest {

        guard var components = URLComponents(
            url: endpoint.url,
            resolvingAgainstBaseURL: false
        ) else {
            throw AuthenticationError.invalidURL
        }

        components.queryItems = (components.queryItems ?? []) + [
            URLQueryItem(name: "api_key", value: try AuthConfiguration.apiKey)
        ]

        guard let url = components.url else {
            throw AuthenticationError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    // MARK: - Request Execution

    private func send<T: TMDBSuccessResponse>(
        _ endpoint: AuthEndpoint,
        body: Data? = nil
    ) async throws -> T {

        let request = try makeRequest(endpoint: endpoint, body: body)
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw AuthenticationError.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard (200...299).contains(http.statusCode) else {
            let message = try? decoder
                .decode(TMDBErrorResponse.self, from: data)
                .statusMessage
            throw AuthenticationError.server(
                statusCode: http.statusCode,
                message: message
            )
        }

        let decoded: T
        do {
            decoded = try decoder.decode(T.self, from: data)
        } catch {
            throw AuthenticationError.decodingFailed(error)
        }

        guard decoded.success else {
            throw AuthenticationError.authenticationFailed
        }

        return decoded
    }
}
