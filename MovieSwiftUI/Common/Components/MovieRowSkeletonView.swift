//
//  MovieRowSkeletonView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Movie Row Skeleton View

struct MovieRowSkeletonView: View {

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {

            // Poster
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(placeholderColor)
                .frame(width: 70, height: 105)

            // Info
            VStack(alignment: .leading, spacing: 10) {
                bar(width: 160, height: 16)
                bar(width: 50, height: 12)
                bar(width: 40, height: 12)
            }

            Spacer(minLength: 0)
        }
        .accessibilityHidden(true)
    }

    // MARK: - Helpers

    private var placeholderColor: Color {
        Color.white.opacity(0.08)
    }

    private func bar(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(placeholderColor)
            .frame(width: width, height: height)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ForEach(0..<4, id: \.self) { _ in
            MovieRowSkeletonView()
        }
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
