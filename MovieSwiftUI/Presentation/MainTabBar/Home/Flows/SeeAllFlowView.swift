//
//  SeeAllFlowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//



import SwiftUI

// MARK: - See All Flow View

struct SeeAllFlowView: View {

    // MARK: - Dependencies

    @StateObject private var viewModel: SeeAllViewModel

    // MARK: - Initialization

    init(
        category: MovieCategory,
        fetchMoviesUseCase: any FetchMoviesUseCase,
        fetchGenresUseCase: any FetchGenresUseCase
    ) {
        _viewModel = StateObject(
            wrappedValue: SeeAllViewModel(
                category: category,
                fetchMoviesUseCase: fetchMoviesUseCase,
                fetchGenresUseCase: fetchGenresUseCase
            )
        )
    }

    // MARK: - Body

    var body: some View {
        SeeAllView(viewModel: viewModel)
    }
}
