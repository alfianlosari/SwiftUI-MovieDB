//
//  RequestTokenResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
// MARK: - Request Token Response
 
struct RequestTokenResponseDTO: TMDBSuccessResponse {
    let success: Bool
    let requestToken: String
    let expiresAt: String
}
