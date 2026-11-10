//
//  MovieDetailsResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Movie Details Response DTO

struct MovieDetailsResponseDTO: Decodable {

    // MARK: - Properties

    let id: Int
    let title: String
    let tagline: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let runtime: Int?
    let genres: [GenreDTO]?

    // MARK: - Genre

    struct GenreDTO: Decodable {
        let id: Int
        let name: String
    }
}

// MARK: - Mapping

extension MovieDetailsResponseDTO {

    func toDomain() -> MovieDetails {
        MovieDetails(
            id: id,
            title: title,
            tagline: tagline ?? "",
            overview: overview ?? "",
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage ?? 0,
            releaseYear: String((releaseDate ?? "").prefix(4)),
            runtimeMinutes: runtime,
            genres: (genres ?? []).map(\.name)
        )
    }
}
