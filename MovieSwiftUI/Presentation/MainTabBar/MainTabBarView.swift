//
//  MainTabBarView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import SwiftUI

// MARK: - Main Tab Bar View

struct MainTabBarView: View {

    // MARK: - Dependencies

    @State private var homeContainer = HomeDIContainer()

    // MARK: - Body

    var body: some View {
        TabView {

            // MARK: - Home Tab

            homeContainer.makeHomeFlowView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            // MARK: - Movies Tab

            NavigationStack {
                Text("Movies Screen")
                    .navigationTitle("Movies")
            }
            .tabItem {
                Label("Movies", systemImage: "magnifyingglass")
            }

            // MARK: - Profile Tab

            NavigationStack {
                Text("Profile Screen")
                    .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
        .tint(AppTheme.accent)
    }
}

