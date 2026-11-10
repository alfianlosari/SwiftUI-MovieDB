//
//  AuthViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation
import Combine

// MARK: - Auth ViewModel

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var authState: AuthState = .unauthenticated
    @Published var errorMessage: String?
    @Published var authorizationURL: URL?

    private(set) var pendingRequestToken: String?

    // MARK: - Dependencies

    private let createGuestSessionUseCase: any CreateGuestSessionUseCase
    private let createRequestTokenUseCase: any CreateRequestTokenUseCase
    private let createSessionUseCase: any CreateSessionUseCase

    private let keychain: KeychainManager

    // MARK: - Initialization

    init(
        createGuestSession: any CreateGuestSessionUseCase,
        createRequestToken: any CreateRequestTokenUseCase,
        createSession: any CreateSessionUseCase,
        keychain: KeychainManager = .shared,
        restoreOnInit: Bool = true
    ) {
        self.createGuestSessionUseCase = createGuestSession
        self.createRequestTokenUseCase = createRequestToken
        self.createSessionUseCase = createSession
        self.keychain = keychain

        if restoreOnInit {
            restoreSession()
        }
    }

    // MARK: - Loading State

    var isLoading: Bool {
        authState == .loading
    }

    // MARK: - Restore Session

    func restoreSession() {
        if keychain.read(for: .sessionId) != nil {
            authState = .authenticated

        } else if keychain.read(for: .guestSessionId) != nil {
            authState = .guest

        } else {
            authState = .unauthenticated
        }
    }

    // MARK: - Continue as Guest

    func continueAsGuest() async {
        guard !isLoading else { return }

        let previousState = authState

        authState = .loading
        errorMessage = nil

        do {
            let guestSession = try await
                createGuestSessionUseCase.execute()

            guard guestSession.expiresAt > Date() else {
                throw AuthViewModelError.expiredSession
            }

            let saved = keychain.save(
                guestSession.id,
                for: .guestSessionId
            )

            guard saved else {
                throw AuthViewModelError.storageFailed
            }

            authState = .guest

        } catch {
            errorMessage = error.localizedDescription
            authState = previousState
        }
    }

    // MARK: - TMDB Sign In

    func startTMDBSignIn() async {
        guard !isLoading else { return }

        authState = .loading
        errorMessage = nil
        authorizationURL = nil
        pendingRequestToken = nil

        do {
            let token = try await
                createRequestTokenUseCase.execute()

            guard let url = AuthConfiguration.authorizationURL(
                requestToken: token
            ) else {
                throw URLError(.badURL)
            }

            pendingRequestToken = token
            authorizationURL = url

            authState = .unauthenticated

        } catch {
            errorMessage = error.localizedDescription
            authState = .unauthenticated
        }
    }

    // MARK: - Complete TMDB Sign In

    func completeSignIn() async {
        guard let requestToken = pendingRequestToken else {
            return
        }

        authState = .loading
        errorMessage = nil

        defer {
            pendingRequestToken = nil
            authorizationURL = nil
        }

        do {
            let sessionId = try await
                createSessionUseCase.execute(
                    requestToken: requestToken
                )

            let saved = keychain.save(
                sessionId,
                for: .sessionId
            )

            guard saved else {
                throw AuthViewModelError.storageFailed
            }

            keychain.delete(for: .guestSessionId)
            authState = .authenticated

        } catch {
            authState = .unauthenticated
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Sign Out

    func signOut() {
        keychain.clearAll()

        pendingRequestToken = nil
        authorizationURL = nil
        errorMessage = nil

        authState = .unauthenticated
    }
}

// MARK: - ViewModel Errors

enum AuthViewModelError: LocalizedError {

    case storageFailed
    case expiredSession

    var errorDescription: String? {
        switch self {
        case .storageFailed:
            return "Failed to save authentication session."

        case .expiredSession:
            return "The guest session has expired."
        }
    }
}
