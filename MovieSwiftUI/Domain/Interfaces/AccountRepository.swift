//
//  AccountRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Account Repository

protocol AccountRepository: Sendable {

    // MARK: - Movie Account States

    func fetchMovieAccountStates(
        movieID: Int,
        sessionID: String
    ) async throws -> MovieAccountStates

    // MARK: - Favorites & Watchlist

    func updateMovie(
        movieID: Int,
        action: MovieAccountAction,
        isAdded: Bool,
        sessionID: String
    ) async throws

    // MARK: - User Lists

    func fetchUserLists(
        sessionID: String
    ) async throws -> [UserList]

    func createList(
        name: String,
        description: String,
        sessionID: String
    ) async throws -> Int

    func addMovieToList(
        movieID: Int,
        listID: Int,
        sessionID: String
    ) async throws

    func removeMovieFromList(
        movieID: Int,
        listID: Int,
        sessionID: String
    ) async throws
}

