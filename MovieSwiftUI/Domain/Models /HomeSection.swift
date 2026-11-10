//
//  HomeModels.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Home Section

struct HomeSection: Identifiable, Sendable {
    let category: MovieCategory
    let movies: [MovieSummary]
    let errorMessage: String?

    var id: String { category.rawValue }
}
