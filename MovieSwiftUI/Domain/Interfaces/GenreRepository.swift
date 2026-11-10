//
//  GenreRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Genre Repository

protocol GenreRepository: Sendable {

    func fetchGenres(for mediaType: MediaType) async throws -> [GenreFilter]
}
