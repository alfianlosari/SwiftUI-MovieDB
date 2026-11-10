//
//  MovieRowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Movie Row View

struct MovieRowView: View {

    // MARK: - Properties

    let movie: MovieSummary

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            
            // MARK: - Poster
            
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color.white.opacity(0.08)
                }
            }
            .frame(width: 70, height: 105)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            // MARK: - Info
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                if !movie.releaseYear.isEmpty {
                    Text(movie.releaseYear)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Label(movie.ratingText, systemImage: "star.fill")
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
            }
            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview {
    MovieRowView(
        movie: MovieSummary(
            id: 1,
            title: "The Dark Knight",
            posterPath: nil,
            voteAverage: 8.5,
            genreIds: [],
            releaseYear: "2008"
        )
    )
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
