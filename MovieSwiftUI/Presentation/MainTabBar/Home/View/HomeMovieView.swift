//
//  HomeMovieView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import SwiftUI

// MARK: - Home Movie View

struct HomeMovieView: View {

    let movie: MovieSummary

    private let cardWidth: CGFloat = 116
    private let posterHeight: CGFloat = 158

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // MARK: - Poster

            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    posterPlaceholder
                        .overlay {
                            ProgressView()
                        }

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    posterPlaceholder

                @unknown default:
                    posterPlaceholder
                }
            }
            .frame(width: cardWidth, height: posterHeight)
            .clipped()
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )

            // MARK: - Title

            Text(movie.title)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(
                    width: cardWidth,
                    height: 38,
                    alignment: .topLeading
                )

            // MARK: - Rating

            HStack(spacing: 5) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)

                Text(movie.ratingText)
                    .foregroundStyle(.white)
            }
            .font(.system(size: 14))
        }
        .frame(width: cardWidth, alignment: .topLeading)
    }

    // MARK: - Placeholder

    private var posterPlaceholder: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.25))
            .overlay {
                Image(systemName: "film")
                    .foregroundStyle(.gray)
            }
    }
}
