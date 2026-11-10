//
//  AuthEndpoints.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation
 
// MARK: - Auth Endpoint
 
enum AuthEndpoint: APIEndpoint {
 
    case guestSession
    case requestToken
    case createSession(requestToken: String)
 
    // MARK: - Path
 
    var path: String {
        switch self {
        case .guestSession: return "authentication/guest_session/new"
        case .requestToken: return "authentication/token/new"
        case .createSession: return "authentication/session/new"
        }
    }
 
    // MARK: - Method
 
    var method: HTTPMethod {
        switch self {
        case .guestSession, .requestToken: return .get
        case .createSession: return .post
        }
    }
 
    // MARK: - Body
 
    var body: Data? {
        switch self {
        case .createSession(let requestToken):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(
                CreateSessionBody(requestToken: requestToken)
            )
 
        case .guestSession, .requestToken:
            return nil
        }
    }
}
 
// MARK: - Request Body
 
private struct CreateSessionBody: Encodable {
    let requestToken: String
}
 
