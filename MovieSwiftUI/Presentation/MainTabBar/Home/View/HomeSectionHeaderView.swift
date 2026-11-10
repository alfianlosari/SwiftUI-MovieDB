//
//  HomeSectionHeaderView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Home Section Header View

struct HomeSectionHeaderView: View {

    // MARK: - Properties

    let category: MovieCategory

    // MARK: - Body

    var body: some View {
        HStack {
            Text(category.title)
                .font(.headline.weight(.bold))
                .foregroundColor(.primary)

            Spacer()

            NavigationLink(value: category) {
                Text("See All")
                    .font(.headline)
                    .foregroundStyle(.tint)
            }
        }
    }
}
