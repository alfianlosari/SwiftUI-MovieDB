//
//  SafariView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 22/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import SwiftUI
import SafariServices

struct TMDBSafariView: UIViewControllerRepresentable {

    // MARK: - Properties

    let url: URL
    var onDismiss: (() -> Void)? = nil

    // MARK: - Coordinator

    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }

    // MARK: - Create Safari

    func makeUIViewController(
        context: Context
    ) -> SFSafariViewController {

        let safari = SFSafariViewController(url: url)

        safari.delegate = context.coordinator

        return safari
    }

    // MARK: - Update Safari

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: Context
    ) {
        // No updates needed
    }

    // MARK: - Safari Delegate

    final class Coordinator: NSObject,
        SFSafariViewControllerDelegate {

        let onDismiss: (() -> Void)?

        init(onDismiss: (() -> Void)?) {
            self.onDismiss = onDismiss
        }

        func safariViewControllerDidFinish(
            _ controller: SFSafariViewController
        ) {
            onDismiss?()
        }
    }
}
