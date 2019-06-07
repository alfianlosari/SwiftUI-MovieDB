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

final class MovieHomeData: BindableObject {
    
    let didChange = PassthroughSubject<MovieHomeData, Never>()
    private let movieService: MovieService
    
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
                self.movieService.fetchMovies(from: endpoint, params: nil, successHandler: {  (response) in
                    rows.append(MovieHomeRow(categoryName: endpoint.description, movies: response.results, order: index))
                    group.leave()
                }) { (error) in
                    print(error.localizedDescription)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.isLoading = false
            rows.sort { $0.order < $1.order }
            self.movies = rows
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            didChange.send(self)
        }
    }
    
    var movies: [MovieHomeRow] = [] {
        didSet {
            didChange.send(self)
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
