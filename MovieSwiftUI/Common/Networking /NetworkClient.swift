//
//  NetworkClient.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
 
// MARK: - Network Error
 
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case server(statusCode: Int, message: String?)
    case decodingFailed(Error)
 
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .server(let statusCode, let message):
            return message ?? "Request failed with status: \(statusCode)"
        case .decodingFailed:
            return "Failed to read the server response."
        }
    }
}
 
private struct TMDBErrorBody: Decodable {
    let statusMessage: String
}
 
// MARK: - Network Client
 
final class NetworkClient: Sendable {
 
    // MARK: - Dependencies
 
    private let session: URLSession
    private let baseURL: URL
    private let apiKeyProvider: @Sendable () throws -> String
 
    // MARK: - Initialization
 
    init(
        session: URLSession = .shared,
        baseURL: URL = AuthConfiguration.baseURL,
        apiKeyProvider: @escaping @Sendable () throws -> String = {
            try AuthConfiguration.apiKey
        }
    ) {
        self.session = session
        self.baseURL = baseURL
        self.apiKeyProvider = apiKeyProvider
    }
 
    // MARK: - Request
 
    func request<T: Decodable>(
        _ endpoint: any APIEndpoint
    ) async throws -> T {
 
        let urlRequest = try makeURLRequest(for: endpoint)
        let (data, response) = try await session.data(for: urlRequest)
 
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
 
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
 
        guard (200...299).contains(http.statusCode) else {
            let message = try? decoder
                .decode(TMDBErrorBody.self, from: data)
                .statusMessage
 
            throw NetworkError.server(
                statusCode: http.statusCode,
                message: message
            )
        }
 
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
 
    // MARK: - Request Building
 
    private func makeURLRequest(
        for endpoint: any APIEndpoint
    ) throws -> URLRequest {
 
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }
 
        components.queryItems = endpoint.queryItems + [
            URLQueryItem(name: "api_key", value: try apiKeyProvider())
        ]
 
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
 
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
 
        if let body = endpoint.body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
 
        return request
    }
}
 
