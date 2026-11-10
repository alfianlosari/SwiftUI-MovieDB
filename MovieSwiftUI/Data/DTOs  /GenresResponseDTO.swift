//
//  GenresResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Genres Response DTO


struct GenresResponseDTO: Decodable {

    let genres: [GenreDTO]

    struct GenreDTO: Decodable {
        let id: Int
        let name: String
    }
}

// MARK: - Mapping to Domain

extension GenresResponseDTO {

    func toDomain() -> [GenreFilter] {
        genres.map { GenreFilter(id: $0.id, name: $0.name) }
    }
}
