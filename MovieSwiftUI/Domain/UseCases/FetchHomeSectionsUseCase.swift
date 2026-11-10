//
//  FetchHomeSectionsUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Use Case

protocol FetchHomeSectionsUseCase: Sendable {

    func execute(categories: [MovieCategory]) async -> [HomeSection]
}

// MARK: - Default Implementation

struct DefaultFetchHomeSectionsUseCase: FetchHomeSectionsUseCase {

    private let repository: any MovieListRepository
    private let moviesPerSection: Int

    init(
        repository: any MovieListRepository,
        moviesPerSection: Int = 10
    ) {
        self.repository = repository
        self.moviesPerSection = moviesPerSection
    }

    func execute(categories: [MovieCategory]) async -> [HomeSection] {

        let repository = self.repository
        let limit = moviesPerSection

        let results = await withTaskGroup(
            of: (Int, HomeSection).self
        ) { group in
            for (index, category) in categories.enumerated() {
                group.addTask {
                    do {
                        let page = try await repository.fetchMovies(
                            category: category,
                            page: 1
                        )
                        return (
                            index,
                            HomeSection(
                                category: category,
                                movies: Array(page.movies.prefix(limit)),
                                errorMessage: nil
                            )
                        )
                    } catch {
                        let isCancellation =
                            error is CancellationError ||
                            (error as? URLError)?.code == .cancelled

                        return (
                            index,
                            HomeSection(
                                category: category,
                                movies: [],
                                errorMessage: isCancellation
                                    ? nil
                                    : error.localizedDescription
                            )
                        )
                    }
                }
            }

            var collected: [(Int, HomeSection)] = []
            for await item in group {
                collected.append(item)
            }
            return collected
        }

        return results.sorted { $0.0 < $1.0 }.map(\.1)
    }
}
