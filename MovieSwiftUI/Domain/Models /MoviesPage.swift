//
//  SeeAllModels.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Movies Page

struct MoviesPage: Sendable {
    let movies: [MovieSummary]
    let page: Int
    let totalPages: Int
}
