//
//  MovieAction.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Movie Account States

struct MovieAccountStates: Equatable, Sendable {
    var isFavorite: Bool
    var isInWatchlist: Bool
}

// MARK: - Movie Action

enum MovieAccountAction: Sendable {
    case favorite
    case watchlist
}

// MARK: - User List

struct UserList: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let itemCount: Int
}
