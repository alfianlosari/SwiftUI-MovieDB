//
//  MovieEndpoint.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Movie Endpoint

enum MovieEndpoint: APIEndpoint {

    case list(category: MovieCategory, page: Int)
    case details(id: Int)

    // MARK: - Path

    var path: String {
        switch self {
        case .list(let category, _):
            return "movie/\(category.rawValue)"

        case .details(let id):
            return "movie/\(id)"
        }
    }

    // MARK: - Method

    var method: HTTPMethod {
        switch self {
        case .list, .details:
            return .get
        }
    }

    // MARK: - Query Items

    var queryItems: [URLQueryItem] {
        switch self {
        case .list(_, let page):
            return [URLQueryItem(name: "page", value: String(page))]

        case .details:
            return []
        }
    }
}
