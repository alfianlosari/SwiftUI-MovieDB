//
//  MediaType.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Media Type

enum MediaType: String, CaseIterable, Sendable {
    case movie
    case tv

    var title: String {
        switch self {
        case .movie: return "Movies"
        case .tv: return "TV Shows"
        }
    }
}
