//
//  AppFlow.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

enum AppFlow: Equatable {
    case welcome
    case main

    init(authState: AuthState) {
        switch authState {
        case .unauthenticated, .loading:
            self = .welcome

        case .guest, .authenticated:
            self = .main
        }
    }
}
