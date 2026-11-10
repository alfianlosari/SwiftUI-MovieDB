//
//  MovieDetailsViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Combine

// MARK: - Movie Details View Model

@MainActor
final class MovieDetailsViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case loading
        case loaded(MovieDetails)
        case failed(String)
    }

    // MARK: - Published Properties

    @Published private(set) var state: State = .loading

    @Published private(set) var isFavorite = false
    @Published private(set) var isInWatchlist = false

    @Published private(set) var isUpdatingFavorite = false
    @Published private(set) var isUpdatingWatchlist = false

    @Published private(set) var actionErrorMessage: String?

    // MARK: - Dependencies

    private let movieID: Int

    private let fetchMovieDetails: any FetchMovieDetailsUseCase

    private let fetchAccountStates: any FetchMovieAccountStatesUseCase

    private let updateMovieAccount: any UpdateMovieAccountUseCase

    private let sessionID: String?

    // MARK: - Initialization

    init(
        movieID: Int,
        fetchMovieDetails: any FetchMovieDetailsUseCase,
        fetchAccountStates: any FetchMovieAccountStatesUseCase,
        updateMovieAccount: any UpdateMovieAccountUseCase,
        sessionID: String?
    ) {
        self.movieID = movieID
        self.fetchMovieDetails = fetchMovieDetails
        self.fetchAccountStates = fetchAccountStates
        self.updateMovieAccount = updateMovieAccount
        self.sessionID = sessionID
    }

    // MARK: - Initial Loading

    func loadIfNeeded() async {
        guard case .loading = state else { return }

        await load()
    }

    // MARK: - Load Movie Details

    func load() async {
        do {
            let details = try await fetchMovieDetails.execute(
                id: movieID
            )

            state = .loaded(details)

            await loadAccountStates()

        } catch is CancellationError {
            return

        } catch let error as URLError
            where error.code == .cancelled {
            return

        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    // MARK: - Load Account States

    func loadAccountStates() async {
        guard let sessionID, !sessionID.isEmpty else {
            return
        }

        do {
            let result = try await fetchAccountStates.execute(
                movieID: movieID,
                sessionID: sessionID
            )

            isFavorite = result.isFavorite
            isInWatchlist = result.isInWatchlist

        } catch is CancellationError {
            return

        } catch {
            actionErrorMessage = error.localizedDescription
        }
    }

    // MARK: - Toggle Favorite

    func toggleFavorite() async {
        guard !isUpdatingFavorite else { return }

        guard let sessionID, !sessionID.isEmpty else {
            actionErrorMessage = "Please sign in to use Favorites."
            return
        }

        isUpdatingFavorite = true
        actionErrorMessage = nil

        defer {
            isUpdatingFavorite = false
        }

        let newValue = !isFavorite

        do {
            try await updateMovieAccount.execute(
                movieID: movieID,
                action: .favorite,
                isAdded: newValue,
                sessionID: sessionID
            )

            isFavorite = newValue

        } catch {
            actionErrorMessage = error.localizedDescription
        }
    }

    // MARK: - Toggle Watchlist

    func toggleWatchlist() async {
        guard !isUpdatingWatchlist else { return }

        guard let sessionID, !sessionID.isEmpty else {
            actionErrorMessage = "Please sign in to use Watchlist."
            return
        }

        isUpdatingWatchlist = true
        actionErrorMessage = nil

        defer {
            isUpdatingWatchlist = false
        }

        let newValue = !isInWatchlist

        do {
            try await updateMovieAccount.execute(
                movieID: movieID,
                action: .watchlist,
                isAdded: newValue,
                sessionID: sessionID
            )

            isInWatchlist = newValue

        } catch {
            actionErrorMessage = error.localizedDescription
        }
    }

    // MARK: - Retry

    func retry() async {
        state = .loading
        actionErrorMessage = nil

        await load()
    }

    // MARK: - Dismiss Action Error

    func clearActionError() {
        actionErrorMessage = nil
    }
}
