//
//  SafariView.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 07/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

    }
    
    
    
}


