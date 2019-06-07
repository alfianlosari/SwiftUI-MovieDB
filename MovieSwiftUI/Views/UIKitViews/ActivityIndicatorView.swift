//
//  ActivityIndicatorView.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 06/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.hidesWhenStopped = true
        uiView.startAnimating()
    }
    
}
