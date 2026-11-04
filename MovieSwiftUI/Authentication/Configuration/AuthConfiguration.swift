//
//  AuthConfiguration.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 23/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Authentication Configuration

enum AuthConfiguration {

    // MARK: - TMDB URLs

    static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    static let authorizationBaseURL = URL(string: "https://www.themoviedb.org/authenticate")!

    // MARK: - API Key

    static var apiKey: String {
        get throws {
            guard let rawKey = Bundle.main.object(
                forInfoDictionaryKey: "TMDB_API_KEY"
            ) as? String else {
                throw AuthenticationError.missingAPIKey
            }

            let key = rawKey.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !key.isEmpty, !key.hasPrefix("$(") else {
                throw AuthenticationError.missingAPIKey
            }

            return key
        }
    }

    // MARK: - Authorization URL

    static func authorizationURL(
        requestToken: String,
        redirectTo: String? = nil
    ) -> URL? {
        var components = URLComponents(
            url: authorizationBaseURL.appendingPathComponent(requestToken),
            resolvingAgainstBaseURL: false
        )

        if let redirectTo {
            components?.queryItems = [
                URLQueryItem(name: "redirect_to", value: redirectTo)
            ]
        }

        return components?.url
    }
}
