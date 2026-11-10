//
//  AuthRootView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 22/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

struct AppRootView: View {
    
    // MARK: - ViewModel
    
    @StateObject private var authViewModel = AuthDIContainer().makeAuthViewModel()
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch AppFlow(authState: authViewModel.authState) {
                
            case .welcome:
                WelcomeView()
                
            case .main:
                MainTabBarView()
            }
        }
        .environmentObject(authViewModel)
    }
}
