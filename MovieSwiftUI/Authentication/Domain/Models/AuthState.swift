//
//  AuthState.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

enum AuthState: Equatable {
    case unauthenticated
    case loading
    case guest
    case authenticated
}
