//
//  MovieCategory.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Movie Category

enum MovieCategory: String, CaseIterable, Sendable {

    case nowPlaying = "now_playing"
    case popular
    case topRated = "top_rated"
    case upcoming

    // MARK: - Title

    var title: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"

        case .popular:
            return "Popular"

        case .topRated:
            return "Top Rated"

        case .upcoming:
            return "Upcoming"
        }
    }
}

