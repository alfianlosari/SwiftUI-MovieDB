//
//  MovieItem.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 05/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MovieItem : View {
    
    var movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MovieItemImage(imageData: ImageData(movieURL: movie.backdropURL))
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .foregroundColor(.primary)
                    .font(.headline)
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 40)
                }
            }
    }
}

struct MovieItemImage: View {
    
    @State var imageData: ImageData

    var body: some View {
        ZStack {
            if self.imageData.image != nil {
                Image(uiImage: self.imageData.image!)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 300, height: 169)
                    .cornerRadius(5)
                    .shadow(radius: 10)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 169)
                    .cornerRadius(5)
                    .shadow(radius: 10)
            }
            }.onAppear {
                self.imageData.downloadImage()
        }
    }
}

#if DEBUG
struct MovieItem_Previews : PreviewProvider {
    static var previews: some View {
        MovieItem(movie: Movie.fake)
        
    }
}
#endif
