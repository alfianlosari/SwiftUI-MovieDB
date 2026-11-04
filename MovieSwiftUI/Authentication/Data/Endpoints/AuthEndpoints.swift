//
//  AuthEndpoints.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - Auth Endpoint

enum AuthEndpoint {

    case guestSession
    case requestToken
    case createSession

    private var path: String {
        switch self {
        case .guestSession: return "authentication/guest_session/new"
        case .requestToken: return "authentication/token/new"
        case .createSession: return "authentication/session/new"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .guestSession, .requestToken: return .get
        case .createSession: return .post
        }
    }

    var url: URL {
        AuthConfiguration.baseURL.appendingPathComponent(path)
    }
}
