//
//  GenreEndpoint.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Genre Endpoint

enum GenreEndpoint: APIEndpoint {

    case list(mediaType: MediaType)

    // MARK: - Path

    var path: String {
        switch self {
        case .list(let mediaType):
            return "genre/\(mediaType.rawValue)/list"
        }
    }

    // MARK: - Method

    var method: HTTPMethod {
        .get
    }
}
