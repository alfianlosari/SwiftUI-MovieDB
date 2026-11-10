//
//  CreateSessionResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
// MARK: - Create Session Response
 
struct CreateSessionResponseDTO: TMDBSuccessResponse {
    let success: Bool
    let sessionId: String
}
 
