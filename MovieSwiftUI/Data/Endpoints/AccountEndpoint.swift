//
//  AccountEndpoint.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Account Endpoint

enum AccountEndpoint: APIEndpoint {

    // MARK: - Account Details

    case accountDetails(
        sessionID: String
    )

    // MARK: - Account States

    case movieAccountStates(
        movieID: Int,
        sessionID: String
    )

    // MARK: - Favorites & Watchlist

    case updateMovie(
        accountID: Int,
        movieID: Int,
        action: MovieAccountAction,
        isAdded: Bool,
        sessionID: String
    )

    // MARK: - User Lists

    case userLists(
        accountID: Int,
        sessionID: String
    )

    case createList(
        name: String,
        description: String,
        sessionID: String
    )

    case addMovie(
        listID: Int,
        movieID: Int,
        sessionID: String
    )

    case removeMovie(
        listID: Int,
        movieID: Int,
        sessionID: String
    )

    // MARK: - Path

    var path: String {
        switch self {

        case .accountDetails:
            return "account"

        case .movieAccountStates(let movieID, _):
            return "movie/\(movieID)/account_states"

        case .updateMovie(let accountID, _, let action, _, _):
            switch action {
            case .favorite:
                return "account/\(accountID)/favorite"

            case .watchlist:
                return "account/\(accountID)/watchlist"
            }

        case .userLists(let accountID, _):
            return "account/\(accountID)/lists"

        case .createList:
            return "list"

        case .addMovie(let listID, _, _):
            return "list/\(listID)/add_item"

        case .removeMovie(let listID, _, _):
            return "list/\(listID)/remove_item"
        }
    }

    // MARK: - HTTP Method

    var method: HTTPMethod {
        switch self {

        case .accountDetails,
             .movieAccountStates,
             .userLists:
            return .get

        case .updateMovie,
             .createList,
             .addMovie,
             .removeMovie:
            return .post
        }
    }

    // MARK: - Query Items

    var queryItems: [URLQueryItem] {
        let sessionID: String

        switch self {

        case .accountDetails(let session):
            sessionID = session

        case .movieAccountStates(_, let session):
            sessionID = session

        case .updateMovie(_, _, _, _, let session):
            sessionID = session

        case .userLists(_, let session):
            sessionID = session

        case .createList(_, _, let session):
            sessionID = session

        case .addMovie(_, _, let session):
            sessionID = session

        case .removeMovie(_, _, let session):
            sessionID = session
        }

        return [
            URLQueryItem(
                name: "session_id",
                value: sessionID
            )
        ]
    }

    // MARK: - Request Body

    var body: Data? {
        switch self {

        case .accountDetails,
             .movieAccountStates,
             .userLists:
            return nil

        case .updateMovie(
            _,
            let movieID,
            let action,
            let isAdded,
            _
        ):
            let actionKey: String

            switch action {
            case .favorite:
                actionKey = "favorite"

            case .watchlist:
                actionKey = "watchlist"
            }

            return makeJSON([
                "media_type": "movie",
                "media_id": movieID,
                actionKey: isAdded
            ])

        case .createList(let name, let description, _):
            return makeJSON([
                "name": name,
                "description": description,
                "language": "en"
            ])

        case .addMovie(_, let movieID, _),
             .removeMovie(_, let movieID, _):
            return makeJSON([
                "media_id": movieID
            ])
        }
    }

    // MARK: - JSON Helper

    private func makeJSON(
        _ dictionary: [String: Any]
    ) -> Data? {
        try? JSONSerialization.data(
            withJSONObject: dictionary
        )
    }
}
