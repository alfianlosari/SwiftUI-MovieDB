//
//  GenreFilterView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 28/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Genre Filter View

struct GenreFilterView: View {

    // MARK: - Properties

    let genres: [GenreFilter]
    let selectedGenre: GenreFilter?
    let onSelect: (GenreFilter?) -> Void

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {

                chip(
                    title: "All",
                    isSelected: selectedGenre == nil
                ) {
                    onSelect(nil)
                }

                ForEach(genres) { genre in
                    chip(
                        title: genre.name,
                        isSelected: selectedGenre == genre
                    ) {
                        onSelect(genre)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    // MARK: - Chip

    private func chip(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(
                    isSelected ? Color.white : Color.white.opacity(0.75)
                )
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    Capsule().fill(
                        isSelected
                            ? AppTheme.accent
                            : Color.white.opacity(0.08)
                    )
                )
        }
        .buttonStyle(.plain)
    }
}
