//
//  WelcomeView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 20/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//



import SwiftUI

struct WelcomeView: View {

    // MARK: - ViewModel

    @EnvironmentObject private var authViewModel: AuthViewModel

    // MARK: - State

    @State private var showSafari = false

    // MARK: - Colors

    private let accentColor = Color(
        red: 0.38,
        green: 0.30,
        blue: 0.96
    )

    // MARK: - Body

    var body: some View {
        ZStack {

            // MARK: - Background

            Image("welcomeBackground")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()

            // MARK: - Gradient Overlay

            LinearGradient(
                stops: [
                    .init(
                        color: Color.black.opacity(0.10),
                        location: 0
                    ),
                    .init(
                        color: Color.black.opacity(0.05),
                        location: 0.40
                    ),
                    .init(
                        color: Color(
                            red: 0.04,
                            green: 0.06,
                            blue: 0.15
                        ).opacity(0.65),
                        location: 0.72
                    ),
                    .init(
                        color: Color(
                            red: 0.04,
                            green: 0.06,
                            blue: 0.15
                        ).opacity(0.95),
                        location: 1
                    )
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // MARK: - Content

            VStack(spacing: 0) {

                // MARK: - Logo & Title

                VStack(spacing: 12) {

                    Image(systemName: "movieclapper")
                        .font(.system(size: 55))
                        .foregroundColor(.white)

                    Text("Movies")
                        .font(
                            .system(
                                size: 40,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.white)

                    Text("Discover. Track. Organize.")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .foregroundColor(
                            .white.opacity(0.8)
                        )
                }
                .padding(.top, 115)

                Spacer()

                // MARK: - Buttons

                VStack(spacing: 25) {

                    // MARK: - Continue as Guest

                    Button {
                        Task {
                            await authViewModel.continueAsGuest()
                        }
                    } label: {

                        Label(
                            "Continue as Guest",
                            systemImage: "person"
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(authViewModel.isLoading)

                    // MARK: - Sign In with TMDB

                    Button {
                        Task {
                            await authViewModel.startTMDBSignIn()

                            if authViewModel.authorizationURL != nil {
                                showSafari = true
                            }
                        }
                    } label: {

                        Label(
                            "Sign In with TMDB",
                            systemImage: "arrow.up.right.square"
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .foregroundColor(.white)
                        .background(
                            Color.black.opacity(0.35)
                        )
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 12
                            )
                            .stroke(
                                Color.white.opacity(0.15),
                                lineWidth: 1
                            )
                        )
                        .cornerRadius(12)
                    }
                    .disabled(authViewModel.isLoading)

                    // MARK: - Loading

                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }

                    // MARK: - Footer

                    Text(
                        "Track your favorites, create lists\nand never lose a movie again."
                    )
                    .font(.footnote)
                    .foregroundColor(
                        .white.opacity(0.7)
                    )
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                }
                .font(
                    .system(
                        size: 15,
                        weight: .semibold
                    )
                )
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 28)
        }
        .ignoresSafeArea()

        // MARK: - Safari Sheet

        
        .sheet(
            isPresented: $showSafari,
            onDismiss: {
                Task {
                    await authViewModel.completeSignIn()
                }
            }
        ) {
            if let url = authViewModel.authorizationURL {
                TMDBSafariView(url: url)
            }
        }

        // MARK: - Error Alert

        .alert(
            "Authentication Error",
            isPresented: Binding(
                get: {
                    authViewModel.errorMessage != nil
                },
                set: { isPresented in
                    if !isPresented {
                        authViewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                authViewModel.errorMessage = nil
            }
        } message: {
            Text(
                authViewModel.errorMessage ?? "Unknown error"
            )
        }
    }
}

// MARK: - Preview

#Preview {
    WelcomeView()
        .environmentObject(
            AuthDIContainer().makeAuthViewModel(restoreOnInit: false)
        )
}

