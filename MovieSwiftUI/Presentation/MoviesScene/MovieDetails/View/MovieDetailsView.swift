//
//  MovieDetailsView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Movie Details View

struct MovieDetailsView: View {

    // MARK: - Properties

    let state: MovieDetailsViewModel.State
    let onRetry: () -> Void
    let isFavorite: Bool
    let isInWatchlist: Bool

    let onFavoriteTap: () -> Void
    let onWatchlistTap: () -> Void
    let onAddToListTap: () -> Void

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch state {
            case .loading:
                ProgressView()
                    .tint(.white)

            case .loaded(let details):
                content(details)

            case .failed(let message):
                errorView(message)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

 
   
    // MARK: - Content

    private func content(_ details: MovieDetails) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                backdrop(details)

                header(details)
                    .padding(.horizontal, 20)
                    .padding(.top, -60)

                // MARK: - Movie Actions
                movieActions
                    .padding(.horizontal, 20)

                if !details.genres.isEmpty {
                    genres(details.genres)
                }

                overview(details)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 32)
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Backdrop

    private func backdrop(_ details: MovieDetails) -> some View {
        Color.clear
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            .overlay {
                AsyncImage(url: details.backdropURL ?? details.posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Color.white.opacity(0.08)
                    }
                }
            }
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [.clear, .black],
                    startPoint: .center,
                    endPoint: .bottom
                )
            )
    }

    // MARK: - Header

    private func header(_ details: MovieDetails) -> some View {
        HStack(alignment: .bottom, spacing: 16) {

            AsyncImage(url: details.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color.white.opacity(0.08)
                }
            }
            .frame(width: 110, height: 165)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                Text(details.title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(3)

                HStack(spacing: 10) {
                    Label(details.ratingText, systemImage: "star.fill")
                        .foregroundStyle(.yellow)

                    if !details.releaseYear.isEmpty {
                        Text(details.releaseYear)
                    }

                    if let runtime = details.runtimeText {
                        Text(runtime)
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
    }
    

    // MARK: - Movie Actions

    private var movieActions: some View {
        HStack(spacing: 10) {

            actionButton(
                title: isInWatchlist ? "In Watchlist" : "Watchlist",
                systemImage: isInWatchlist
                    ? "bookmark.fill"
                    : "bookmark",
                selectedColor: .green,
                isSelected: isInWatchlist,
                action: onWatchlistTap
            )

            actionButton(
                title: isFavorite ? "Favorite" : "Add Favorite",
                systemImage: isFavorite
                    ? "heart.fill"
                    : "heart",
                selectedColor: .red,
                isSelected: isFavorite,
                action: onFavoriteTap
            )

            actionButton(
                title: "Add to List",
                systemImage: "list.bullet",
                selectedColor: AppTheme.accent,
                isSelected: false,
                action: onAddToListTap
            )
        }
    }

    // MARK: - Action Button

    private func actionButton(
        title: String,
        systemImage: String,
        selectedColor: Color,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {

                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(
                        isSelected ? selectedColor : .white
                    )

                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(
                        isSelected ? selectedColor : .white
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 78)
            .background(
                Color.white.opacity(0.08),
                in: RoundedRectangle(cornerRadius: 14)
            )
        }
        .buttonStyle(.plain)
    }



    // MARK: - Genres

    private func genres(_ genres: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(genres, id: \.self) { genre in
                    Text(genre)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(AppTheme.accent.opacity(0.35), in: Capsule())
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Overview

    private func overview(_ details: MovieDetails) -> some View {
        VStack(alignment: .leading, spacing: 10) {

            if !details.tagline.isEmpty {
                Text(details.tagline)
                    .font(.subheadline.italic())
                    .foregroundStyle(.secondary)
            }

            Text("Overview")
                .font(.headline)
                .foregroundStyle(.white)

            Text(details.overview.isEmpty
                 ? "No overview available."
                 : details.overview)
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
        }
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again", action: onRetry)
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
        }
    }
}


// MARK: - Preview

#Preview("Loaded") {
   NavigationStack {
       MovieDetailsView(
           state: .loaded(
               MovieDetails(
                   id: 1,
                   title: "The Dark Knight",
                   tagline: "Welcome to a world without rules.",
                   overview: "Batman raises the stakes in his war on crime.",
                   posterPath: nil,
                   backdropPath: nil,
                   voteAverage: 8.5,
                   releaseYear: "2008",
                   runtimeMinutes: 152,
                   genres: ["Action", "Crime", "Drama"]
               )
           ),
           onRetry: {},
           isFavorite: false,
           isInWatchlist: false,
           onFavoriteTap: {},
           onWatchlistTap: {},
           onAddToListTap: {}
       )
   }
}

#Preview("Error") {
   NavigationStack {
       MovieDetailsView(
           state: .failed("No internet connection."),
           onRetry: {},
           isFavorite: false,
           isInWatchlist: false,
           onFavoriteTap: {},
           onWatchlistTap: {},
           onAddToListTap: {}
       )
   }
}
