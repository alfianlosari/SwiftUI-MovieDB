//
//  GenreFilter.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Genre Filter

struct GenreFilter: Identifiable, Hashable, Sendable {

    let id: Int
    let name: String

    // MARK: - Available Genres

    static let all: [GenreFilter] = [
        GenreFilter(id: 28, name: "Action"),
        GenreFilter(id: 12, name: "Adventure"),
        GenreFilter(id: 16, name: "Animation"),
        GenreFilter(id: 35, name: "Comedy"),
        GenreFilter(id: 80, name: "Crime"),
        GenreFilter(id: 99, name: "Documentary"),
        GenreFilter(id: 18, name: "Drama"),
        GenreFilter(id: 10751, name: "Family"),
        GenreFilter(id: 14, name: "Fantasy"),
        GenreFilter(id: 36, name: "History"),
        GenreFilter(id: 27, name: "Horror"),
        GenreFilter(id: 10402, name: "Music"),
        GenreFilter(id: 9648, name: "Mystery"),
        GenreFilter(id: 10749, name: "Romance"),
        GenreFilter(id: 878, name: "Science Fiction"),
        GenreFilter(id: 53, name: "Thriller"),
        GenreFilter(id: 10752, name: "War"),
        GenreFilter(id: 37, name: "Western")
    ]
}

