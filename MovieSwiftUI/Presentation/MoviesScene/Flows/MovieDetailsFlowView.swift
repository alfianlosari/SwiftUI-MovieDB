//
//  MovieDetailsFlowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import SwiftUI

// MARK: - Movie Details Flow View

struct MovieDetailsFlowView: View {

    // MARK: - Dependencies

    @StateObject private var viewModel: MovieDetailsViewModel

    // MARK: - Initialization

    init(
        movieID: Int,
        fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase,
        fetchAccountStatesUseCase: any FetchMovieAccountStatesUseCase,
        updateMovieAccountUseCase: any UpdateMovieAccountUseCase,
        sessionID: String?
    ) {
        _viewModel = StateObject(
            wrappedValue: MovieDetailsViewModel(
                movieID: movieID,
                fetchMovieDetails: fetchMovieDetailsUseCase,
                fetchAccountStates: fetchAccountStatesUseCase,
                updateMovieAccount: updateMovieAccountUseCase,
                sessionID: sessionID
            )
        )
    }

    // MARK: - Body

    var body: some View {
        MovieDetailsView(
            state: viewModel.state,
            onRetry: {
                Task {
                    await viewModel.retry()
                }
            },
            isFavorite: viewModel.isFavorite,
            isInWatchlist: viewModel.isInWatchlist,
            onFavoriteTap: {
                Task {
                    await viewModel.toggleFavorite()
                }
            },
            onWatchlistTap: {
                Task {
                    await viewModel.toggleWatchlist()
                }
            },
            onAddToListTap: {
                // TODO: Open My Lists sheet
            }
        )
        .task {
            await viewModel.loadIfNeeded()
        }
        .alert(
            "Action Failed",
            isPresented: Binding(
                get: { viewModel.actionErrorMessage != nil },
                set: { if !$0 { viewModel.clearActionError() } }
            )
        ) {
            Button("OK") {
                viewModel.clearActionError()
            }
        } message: {
            Text(viewModel.actionErrorMessage ?? "")
        }
    }
}

// MARK: - Preview

#Preview("Movie Details Flow") {
    NavigationStack {
        MovieDetailsFlowView(
            movieID: 155,
            fetchMovieDetailsUseCase: DefaultFetchMovieDetailsUseCase(
                repository: DefaultMovieDetailsRepository()
            ),
            fetchAccountStatesUseCase: DefaultFetchMovieAccountStatesUseCase(
                repository: DefaultAccountRepository()
            ),
            updateMovieAccountUseCase: DefaultUpdateMovieAccountUseCase(
                repository: DefaultAccountRepository()
            ),
            sessionID: nil
        )
    }
}
