//
//  MovieData.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 06/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Combine
import SwiftUI

struct MovieHomeRow: Identifiable {
    
    var categoryName: String
    var movies: [Movie]
    var order: Int
    
    var id: String {
        return categoryName
    }
    
}

final class MovieHomeData: ObservableObject {
    
    private let movieService: MovieService
    
    @Published var isLoading: Bool = false
    @Published var movies: [MovieHomeRow] = []
    
    init(movieService: MovieService, endpoints: [Endpoint]) {
        self.movieService = movieService
        self.loadMovies(endpoints)
    }
    
    private func loadMovies(_ endpoints: [Endpoint]) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)
        
        var rows: [MovieHomeRow] = []
        isLoading = true
        
        for (index, endpoint) in endpoints.enumerated() {
            queue.async(group: group) {
                group.enter()
                self.movieService.fetchMovies(from: endpoint, params: nil, successHandler: { (response) in
                    rows.append(MovieHomeRow(categoryName: endpoint.description, movies: response.results, order: index))
                    group.leave()
                }) { (error) in
                    print(error.localizedDescription)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            rows.sort { $0.order < $1.order }
            self.movies = rows
        }
    }
}

fileprivate extension Endpoint {

    var homeIndex: Int {
        switch self {
        case .nowPlaying: return 1
        case .upcoming: return 2
        case .popular: return 3
        case .topRated: return 4
        }
    }
    
}
