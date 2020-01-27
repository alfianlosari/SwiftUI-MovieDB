//
//  MessageText.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 07/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MessageText: View {
    
    var text: String
    
    var body: some View {
        Text(self.text)
            .foregroundColor(.primary)
            .lineLimit(2)
            .font(.headline)
            .padding()
    }
}

