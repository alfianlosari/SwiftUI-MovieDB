//
//  MovieRow.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 05/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MovieRow : View {
    
    var categoryName: String
    var movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(self.categoryName)
                .font(.title)
                .padding([.leading, .top])

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 20) {
                    ForEach(self.movies.identified(by: \.title)) { movie in
                        NavigationLink(destination: MovieDetail(movieData: MovieItemData(movieService: MovieStore.shared, movie: movie))) {
                            MovieItem(movie: movie)
                                .frame(width: 300)
                                .padding(.top, 20)
                                .padding(.bottom)
                        }
                    }
                }.offset(x: 16, y: 0)
            }
        }
    }
}

#if DEBUG
struct MovieRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieRow(categoryName: "Popular", movies: Movie.fakes)
    }
}
#endif
