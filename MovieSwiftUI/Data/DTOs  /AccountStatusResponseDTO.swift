//
//  AccountStatusResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Account Status Response DTO

struct AccountStatusResponseDTO: Decodable {

    // MARK: - Properties

    let statusCode: Int
    let statusMessage: String

    // MARK: - Success Validation

    var isSuccessful: Bool {
        [1, 12, 13].contains(statusCode)
    }
}

