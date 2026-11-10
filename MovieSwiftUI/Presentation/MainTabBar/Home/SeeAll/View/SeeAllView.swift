//
//  SeeAllView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - See All View

struct SeeAllView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: SeeAllViewModel

    @State private var isSearching = false
    @FocusState private var isSearchFocused: Bool

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            if isSearching {
                searchBar
            }

            GenreFilterView(
                genres: viewModel.genres,
                selectedGenre: viewModel.selectedGenre
            ) { genre in
                viewModel.select(genre: genre)
            }

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
        .navigationTitle(viewModel.category.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                searchButton
            }
        }
        .task {
            await viewModel.loadIfNeeded()
            await viewModel.loadGenresIfNeeded()
        }
    }

    // MARK: - Search Button

    private var searchButton: some View {
        Button {
            withAnimation {
                isSearching.toggle()
            }

            if isSearching {
                isSearchFocused = true
            } else {
                viewModel.searchText = ""
                isSearchFocused = false
            }
        } label: {
            Image(systemName: isSearching ? "xmark" : "magnifyingglass")
        }
        .accessibilityLabel(isSearching ? "Close search" : "Search")
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.5))

            TextField(
                "Search in \(viewModel.category.title)",
                text: $viewModel.searchText
            )
            .focused($isSearchFocused)
            .submitLabel(.search)
            .autocorrectionDisabled()
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.movies.isEmpty && viewModel.isLoading {
            skeletonList

        } else if viewModel.movies.isEmpty,
                  let message = viewModel.errorMessage {
            errorView(message)

        } else {
            list
        }
    }

    // MARK: - Skeleton

    private var skeletonList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(0..<8, id: \.self) { _ in
                    MovieRowSkeletonView()
                        .padding(.vertical, 10)

                    Divider()
                        .overlay(Color.white.opacity(0.08))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .scrollDisabled(true)
    }

    // MARK: - List

    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink(value: movie) {
                        MovieRowView(movie: movie)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(
                                currentItem: movie
                            )
                        }
                    }

                    Divider()
                        .overlay(Color.white.opacity(0.08))
                }

                // MARK: - Pagination Sentinel

                if viewModel.hasMorePages && viewModel.errorMessage == nil {
                    Color.clear
                        .frame(height: 1)
                        .task(id: viewModel.movies.count) {
                            await viewModel.loadNextPage()
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            // MARK: - Loading More

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .padding()
            }

            // MARK: - Error

            if let message = viewModel.errorMessage {
                errorView(message)
                    .padding()
            }

            // MARK: - Empty State

            if viewModel.filteredMovies.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "No Movies",
                        systemImage: "film",
                        description: Text("No movies found.")
                    )

                    if viewModel.hasMorePages {
                        Button("Load more") {
                            Task { await viewModel.loadNextPage() }
                        }
                        .tint(AppTheme.accent)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Error View

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.loadNextPage() }
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}
