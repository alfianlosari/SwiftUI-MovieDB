//
//  APIEndpoint.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
// MARK: - HTTP Method
 
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
 
// MARK: - API Endpoint
 
protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}
 
extension APIEndpoint {
    var queryItems: [URLQueryItem] { [] }
    var body: Data? { nil }
}
 
