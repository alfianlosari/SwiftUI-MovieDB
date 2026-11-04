//
//  AuthRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

protocol AuthRepository: Sendable {

    func createGuestSession() async throws -> GuestSession

    func createRequestToken() async throws -> String

    func createSession(
        requestToken: String
    ) async throws -> String
}
