//
//  HomeDIContainer.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Home Dependency Injection Container

@MainActor
final class HomeDIContainer {

    // MARK: - Dependencies

    private let repository: any MovieListRepository

    private let detailsRepository: any MovieDetailsRepository

    private let genreRepository: any GenreRepository

    private let accountRepository: any AccountRepository

    // MARK: - Initialization

    init(
        repository: any MovieListRepository = DefaultMovieListRepository(),
        detailsRepository: any MovieDetailsRepository = DefaultMovieDetailsRepository(),
        genreRepository: any GenreRepository = DefaultGenreRepository(),
        accountRepository: any AccountRepository = DefaultAccountRepository()
    ) {
        self.repository = repository
        self.detailsRepository = detailsRepository
        self.genreRepository = genreRepository
        self.accountRepository = accountRepository
    }

    // MARK: - Home Use Cases

    func makeFetchHomeSectionsUseCase() -> any FetchHomeSectionsUseCase {
        DefaultFetchHomeSectionsUseCase(
            repository: repository
        )
    }

    func makeFetchMoviesUseCase() -> any FetchMoviesUseCase {
        DefaultFetchMoviesUseCase(
            repository: repository
        )
    }

    // MARK: - Movie Details Use Case

    func makeFetchMovieDetailsUseCase() -> any FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(
            repository: detailsRepository
        )
    }

    // MARK: - Genres Use Case

    func makeFetchGenresUseCase() -> any FetchGenresUseCase {
        DefaultFetchGenresUseCase(
            repository: genreRepository
        )
    }

    // MARK: - Account States Use Case

    func makeFetchMovieAccountStatesUseCase() -> any FetchMovieAccountStatesUseCase {
        DefaultFetchMovieAccountStatesUseCase(
            repository: accountRepository
        )
    }

    // MARK: - Favorite & Watchlist Use Case

    func makeUpdateMovieAccountUseCase() -> any UpdateMovieAccountUseCase {
        DefaultUpdateMovieAccountUseCase(
            repository: accountRepository
        )
    }

    // MARK: - User Lists Use Case

    func makeFetchUserListsUseCase() -> any FetchUserListsUseCase {
        DefaultFetchUserListsUseCase(
            repository: accountRepository
        )
    }

    
    // MARK: - Home Flow

    func makeHomeFlowView() -> HomeFlowView {
        HomeFlowView(
            fetchSectionsUseCase: makeFetchHomeSectionsUseCase(),
            fetchMoviesUseCase: makeFetchMoviesUseCase(),
            fetchMovieDetailsUseCase: makeFetchMovieDetailsUseCase(),
            fetchGenresUseCase: makeFetchGenresUseCase(),
            fetchAccountStatesUseCase: makeFetchMovieAccountStatesUseCase(),
            updateMovieAccountUseCase: makeUpdateMovieAccountUseCase(),
            sessionID: KeychainManager.shared.read(for: .sessionId)
        )
    }
}
