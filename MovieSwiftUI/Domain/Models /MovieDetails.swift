//
//  MovieDetail.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Movie Detail

struct MovieDetails: Identifiable, Equatable, Sendable {

    // MARK: - Properties

    let id: Int
    let title: String
    let tagline: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseYear: String
    let runtimeMinutes: Int?
    let genres: [String]
}

// MARK: - Presentation Helpers

extension MovieDetails {

    private static let imageBaseURL = "https://image.tmdb.org/t/p"

    var posterURL: URL? {
        posterPath.flatMap {
            URL(string: "\(Self.imageBaseURL)/w500\($0)")
        }
    }

    var backdropURL: URL? {
        backdropPath.flatMap {
            URL(string: "\(Self.imageBaseURL)/w780\($0)")
        }
    }

    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }

    var runtimeText: String? {
        guard let minutes = runtimeMinutes, minutes > 0 else {
            return nil
        }
        return "\(minutes / 60)h \(minutes % 60)m"
    }
}
