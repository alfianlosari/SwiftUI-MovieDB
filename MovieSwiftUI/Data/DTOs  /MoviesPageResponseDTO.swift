//
//  MoviesPageResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Movies Page Response

struct MoviesPageResponseDTO: Decodable {

    let page: Int
    let totalPages: Int
    let results: [MovieDTO]

    struct MovieDTO: Decodable {
        let id: Int
        let title: String?
        let posterPath: String?
        let voteAverage: Double?
        let genreIds: [Int]?
        let releaseDate: String?
    }
}

// MARK: - Mapping to Domain

extension MoviesPageResponseDTO {

    func toDomain() -> MoviesPage {
        MoviesPage(
            movies: results.compactMap { $0.toDomain() },
            page: page,
            totalPages: totalPages
        )
    }
}

extension MoviesPageResponseDTO.MovieDTO {

    func toDomain() -> MovieSummary? {
        guard let title, !title.isEmpty else { return nil }

        return MovieSummary(
            id: id,
            title: title,
            posterPath: posterPath,
            voteAverage: voteAverage ?? 0,
            genreIds: genreIds ?? [],
            releaseYear: String((releaseDate ?? "").prefix(4))
        )
    }
}
