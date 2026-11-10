//
//  MovieSwiftUIApp.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 20/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//



import SwiftUI

@main
struct MovieSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    private let movieStore = MovieStore.shared

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(
                    MovieHomeData(
                        movieService: movieStore,
                        endpoints: Endpoint.allCases
                    )
                )
                .environmentObject(
                    MovieSearchData(movieService: movieStore)
                )
                .environmentObject(KeyboardData())
        }
    }
}
