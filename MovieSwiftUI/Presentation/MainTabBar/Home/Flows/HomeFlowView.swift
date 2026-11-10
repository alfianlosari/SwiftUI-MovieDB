//
//  HomeFlowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import SwiftUI

// MARK: - Home Flow View

struct HomeFlowView: View {

    // MARK: - Dependencies

    @StateObject private var viewModel: HomeViewModel

    private let fetchMoviesUseCase: any FetchMoviesUseCase
    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let fetchGenresUseCase: any FetchGenresUseCase

    private let fetchAccountStatesUseCase: any FetchMovieAccountStatesUseCase
    private let updateMovieAccountUseCase: any UpdateMovieAccountUseCase

    private let sessionID: String?

    // MARK: - Initialization

    init(
        fetchSectionsUseCase: any FetchHomeSectionsUseCase,
        fetchMoviesUseCase: any FetchMoviesUseCase,
        fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase,
        fetchGenresUseCase: any FetchGenresUseCase,
        fetchAccountStatesUseCase: any FetchMovieAccountStatesUseCase,
        updateMovieAccountUseCase: any UpdateMovieAccountUseCase,
        sessionID: String?
    ) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(
                fetchSections: fetchSectionsUseCase
            )
        )

        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.fetchGenresUseCase = fetchGenresUseCase
        self.fetchAccountStatesUseCase = fetchAccountStatesUseCase
        self.updateMovieAccountUseCase = updateMovieAccountUseCase
        self.sessionID = sessionID
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            HomeView(
                sections: viewModel.sections,
                isLoading: viewModel.isLoading
            )
            .toolbar(.hidden, for: .navigationBar)
            .task {
                await viewModel.loadIfNeeded()
            }
            .refreshable {
                await viewModel.load()
            }
            .navigationDestination(for: MovieCategory.self) { category in
                SeeAllFlowView(
                    category: category,
                    fetchMoviesUseCase: fetchMoviesUseCase,
                    fetchGenresUseCase: fetchGenresUseCase
                )
            }
            .navigationDestination(for: MovieSummary.self) { movie in
                MovieDetailsFlowView(
                    movieID: movie.id,
                    fetchMovieDetailsUseCase: fetchMovieDetailsUseCase,
                    fetchAccountStatesUseCase: fetchAccountStatesUseCase,
                    updateMovieAccountUseCase: updateMovieAccountUseCase,
                    sessionID: sessionID
                )
            }
        }
    }
}

// MARK: - Preview

#Preview("Home") {
    let accountRepository = DefaultAccountRepository()

    HomeFlowView(
        fetchSectionsUseCase: DefaultFetchHomeSectionsUseCase(
            repository: DefaultMovieListRepository()
        ),
        fetchMoviesUseCase: DefaultFetchMoviesUseCase(
            repository: DefaultMovieListRepository()
        ),
        fetchMovieDetailsUseCase: DefaultFetchMovieDetailsUseCase(
            repository: DefaultMovieDetailsRepository()
        ),
        fetchGenresUseCase: DefaultFetchGenresUseCase(
            repository: DefaultGenreRepository()
        ),
        fetchAccountStatesUseCase: DefaultFetchMovieAccountStatesUseCase(
            repository: accountRepository
        ),
        updateMovieAccountUseCase: DefaultUpdateMovieAccountUseCase(
            repository: accountRepository
        ),
        sessionID: nil
    )
}
