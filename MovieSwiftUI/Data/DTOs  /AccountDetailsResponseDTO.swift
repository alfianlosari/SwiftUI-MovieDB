//
//  AccountDetailsResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Account Details Response DTO

struct AccountDetailsResponseDTO: Decodable {

    // MARK: - Properties

    let id: Int
    let name: String?
    let username: String

    // MARK: - Account ID

    var accountID: Int {
        id
    }
}

