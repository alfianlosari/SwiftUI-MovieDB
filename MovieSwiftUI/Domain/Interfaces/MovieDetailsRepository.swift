//
//  MovieDetailRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Movie Details Repository

protocol MovieDetailsRepository: Sendable {

    func fetchMovieDetails(id: Int) async throws -> MovieDetails
}
