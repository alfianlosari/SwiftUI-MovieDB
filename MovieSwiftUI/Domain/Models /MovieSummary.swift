//
//  MovieSummary.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Movie Summary

struct MovieSummary: Identifiable, Hashable, Sendable {

    // MARK: - Properties

    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let genreIds: [Int]
    var releaseYear: String = ""

    // MARK: - Poster URL

    var posterURL: URL? {
        guard let posterPath, !posterPath.isEmpty else {
            return nil
        }

        return URL(
            string: "https://image.tmdb.org/t/p/w500\(posterPath)"
        )
    }

    // MARK: - Rating Text

    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }
}

