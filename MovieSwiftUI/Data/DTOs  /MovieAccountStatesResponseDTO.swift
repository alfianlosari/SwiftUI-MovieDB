//
//  MovieAccountStatesResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Movie Account States Response DTO

struct MovieAccountStatesResponseDTO: Decodable {

    // MARK: - Properties

    let id: Int
    let favorite: Bool
    let watchlist: Bool

    // MARK: - Domain Mapping

    func toDomain() -> MovieAccountStates {
        MovieAccountStates(
            isFavorite: favorite,
            isInWatchlist: watchlist
        )
    }
}

