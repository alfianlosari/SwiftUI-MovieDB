//
//  DefaultAuthRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

final class DefaultAuthRepository: AuthRepository {

    // MARK: - Dependencies

    private let authService: AuthenticationService

    init(
        authService: AuthenticationService = AuthenticationService()
    ) {
        self.authService = authService
    }

    // MARK: - Guest Authentication

    func createGuestSession() async throws -> GuestSession {
        let response = try await authService.createGuestSessionResponse()

        return GuestSession(
            id: response.guestSessionId,
            expiresAt: try Self.parseExpirationDate(response.expiresAt)
        )
    }

    // MARK: - Request Token

    func createRequestToken() async throws -> String {
        try await authService.createRequestToken()
    }

    // MARK: - Create User Session

    func createSession(
        requestToken: String
    ) async throws -> String {
        try await authService.createSession(requestToken: requestToken)
    }

    // MARK: - Date Parsing

    private static func parseExpirationDate(_ string: String) throws -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"

        guard let date = formatter.date(from: string) else {
            throw AuthRepositoryError.invalidExpirationDate(string)
        }

        return date
    }
}

// MARK: - Repository Errors

enum AuthRepositoryError: LocalizedError {
    case invalidExpirationDate(String)

    var errorDescription: String? {
        switch self {
        case .invalidExpirationDate(let value):
            return "Invalid guest session expiration date: \(value)"
        }
    }
}
