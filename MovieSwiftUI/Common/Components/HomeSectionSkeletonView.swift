//
//  MovieSkeletonView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import SwiftUI

// MARK: -Movie Skeleton View

struct HomeSectionSkeletonView: View {

    // MARK: - Properties

    var itemsCount: Int = 4

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Section Title Placeholder

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.15))
                .frame(width: 140, height: 20)
                .padding(.horizontal, 20)

            // MARK: - Movies Placeholders

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 20) {

                    ForEach(0..<itemsCount, id: \.self) { _ in
                        skeletonMovieCard
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollDisabled(true)
        }
        .accessibilityHidden(true)
    }

    // MARK: - Skeleton Movie Card

    private var skeletonMovieCard: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Poster
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.15))
                .frame(width: 116, height: 158)

            // Movie Title
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.12))
                .frame(width: 100, height: 14)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.12))
                .frame(width: 70, height: 14)

            // Rating
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.10))
                .frame(width: 45, height: 14)
        }
        .frame(width: 116, alignment: .leading)
    }
}

// MARK: - Preview

#Preview("Movie Skeleton") {
    HomeSectionSkeletonView()
        .padding(.vertical, 20)
        .background(Color.black)
        .preferredColorScheme(.dark)
}
