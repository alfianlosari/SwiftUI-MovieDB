//
//  HomeViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var sections: [HomeSection] = []
    @Published private(set) var isLoading = false

    // MARK: - Dependencies

    private let fetchSectionsUseCase: any FetchHomeSectionsUseCase

    private let categories: [MovieCategory] = [
        .nowPlaying,
        .popular,
        .topRated,
        .upcoming
    ]

    // MARK: - Initialization

    init(fetchSections: any FetchHomeSectionsUseCase) {
        self.fetchSectionsUseCase = fetchSections
    }

    // MARK: - Loading

    func loadIfNeeded() async {
        guard sections.isEmpty else { return }
        await load()
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        let result = await fetchSectionsUseCase.execute(categories: categories)

        guard !Task.isCancelled else { return }

        sections = result
    }
}
