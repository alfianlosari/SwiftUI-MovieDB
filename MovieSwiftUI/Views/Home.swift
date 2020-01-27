//
//  Home.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 05/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            Featured()
                .tag(0)
            Search()
                .tag(1)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#if DEBUG
struct Home_Previews : PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(MovieHomeData(movieService: MovieStore.shared, endpoints: Endpoint.allCases))
            .environmentObject(MovieSearchData(movieService: MovieStore.shared))
            .environmentObject(KeyboardData())
            .colorScheme(.dark)

    }
}
#endif
