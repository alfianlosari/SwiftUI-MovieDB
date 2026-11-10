//
//  HomeView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Home View

struct HomeView: View {

    // MARK: - Properties

    let sections: [HomeSection]
    var isLoading: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header

            Text("Home")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 70)
                .background(Color(white: 0.12))

            // MARK: - Sections

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 32) {
                    if isLoading && sections.isEmpty {
                        ForEach(0..<3, id: \.self) { _ in
                            HomeSectionSkeletonView()
                        }
                    } else {
                        ForEach(sections) { section in
                            homeSection(section)
                        }
                    }
                }
                .padding(.vertical, 20)
            }
            .background(Color.black)
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    // MARK: - Home Section

    @ViewBuilder
    private func homeSection(
        _ section: HomeSection
    ) -> some View {

        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Section Header

            HomeSectionHeaderView(category: section.category)
                .padding(.horizontal, 20)

            // MARK: - Section Error

            if let error = section.errorMessage {
                Text(error)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 20)

            } else {

                // MARK: - Horizontal Movies

                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {
                    LazyHStack(
                        alignment: .top,
                        spacing: 20
                    ) {
                        ForEach(section.movies) { movie in
                            NavigationLink(value: movie) {
                                HomeMovieView(movie: movie)
                                    .frame(width: 100)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Home Screen") {
    NavigationStack {
        HomeView(
            sections: [
                HomeSection(
                    category: .nowPlaying,
                    movies: [],
                    errorMessage: nil
                ),
                HomeSection(
                    category: .popular,
                    movies: [],
                    errorMessage: nil
                ),
                HomeSection(
                    category: .topRated,
                    movies: [],
                    errorMessage: nil
                )
            ]
        )
    }
}
