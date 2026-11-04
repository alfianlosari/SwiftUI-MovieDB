//
//  AuthDIContainer.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 23/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

@MainActor
final class AuthDIContainer {

    // MARK: - Dependencies

    private let repository: any AuthRepository
    private let keychain: KeychainManager

    // MARK: - Initialization

    init(
        repository: any AuthRepository = DefaultAuthRepository(),
        keychain: KeychainManager = .shared
    ) {
        self.repository = repository
        self.keychain = keychain
    }

    // MARK: - Use Cases

    private func makeCreateGuestSessionUseCase() -> any CreateGuestSessionUseCase {
        DefaultCreateGuestSessionUseCase(repository: repository)
    }

    private func makeCreateRequestTokenUseCase() -> any CreateRequestTokenUseCase {
        DefaultCreateRequestTokenUseCase(repository: repository)
    }

    private func makeCreateSessionUseCase() -> any CreateSessionUseCase {
        DefaultCreateSessionUseCase(repository: repository)
    }

    // MARK: - ViewModel

    func makeAuthViewModel(
        restoreOnInit: Bool = true
    ) -> AuthViewModel {
        AuthViewModel(
            createGuestSession: makeCreateGuestSessionUseCase(),
            createRequestToken: makeCreateRequestTokenUseCase(),
            createSession: makeCreateSessionUseCase(),
            keychain: keychain,
            restoreOnInit: restoreOnInit
        )
    }
}
