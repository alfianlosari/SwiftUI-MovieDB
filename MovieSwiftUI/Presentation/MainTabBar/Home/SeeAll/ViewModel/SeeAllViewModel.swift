//
//  SeeAllViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Combine

// MARK: - See All ViewModel

@MainActor
final class SeeAllViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var movies: [MovieSummary] = []
    @Published private(set) var genres: [GenreFilter] = []
    @Published private(set) var isLoadingGenres = false
    @Published private(set) var genresErrorMessage: String?
    @Published private(set) var isLoading = false
    @Published private(set) var hasMorePages = true
    @Published private(set) var errorMessage: String?
    @Published private(set) var selectedGenre: GenreFilter?
    @Published var searchText = ""
    
    // MARK: - Public Properties
    
    let category: MovieCategory
 
    
    // MARK: - Dependencies
    
    private let fetchMoviesUseCase: any FetchMoviesUseCase
    private let fetchGenresUseCase: any FetchGenresUseCase
    
    // MARK: - Pagination
    
    private var currentPage = 0
    private var totalPages = 1
    
    private let minimumVisibleCount = 9
    private let maxAutoLoadPages = 5
    private let maxRefreshPages = 10
    
    // MARK: - Initialization
    
   
    init(
        category: MovieCategory,
        fetchMoviesUseCase: any FetchMoviesUseCase,
        fetchGenresUseCase: any FetchGenresUseCase
    ) {
        self.category = category
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.fetchGenresUseCase = fetchGenresUseCase
    }

    // MARK: - Filtered Movies
    
    var filteredMovies: [MovieSummary] {
        movies.filter { movie in
            let matchesGenre: Bool
            if let genre = selectedGenre {
                matchesGenre = movie.genreIds.contains(genre.id)
            } else {
                matchesGenre = true
            }
            
            let matchesSearch = searchText.isEmpty
            || movie.title.localizedCaseInsensitiveContains(searchText)
            
            return matchesGenre && matchesSearch
        }
    }
    
   
    // MARK: - Initial Loading

    func loadIfNeeded() async {
        guard movies.isEmpty, !isLoading else { return }
        await loadNextPage()
    }

    // MARK: - Load Genres

    func loadGenresIfNeeded() async {
        guard genres.isEmpty, !isLoadingGenres else {
            return
        }

        isLoadingGenres = true
        genresErrorMessage = nil

        defer {
            isLoadingGenres = false
        }

        do {
            genres = try await fetchGenresUseCase.execute(
                mediaType: .movie
            )
        } catch is CancellationError {
            // Ignore cancelled requests
        } catch {
            genresErrorMessage = error.localizedDescription
        }
    }

    
    // MARK: - Load Next Page
    
    func loadNextPage() async {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let result = try await fetchMoviesUseCase.execute(
                category: category,
                page: currentPage + 1
            )
            
            // MARK: - Avoid Duplicate Movies
            
            let existingIDs = Set(movies.map(\.id))
            
            let newMovies = result.movies.filter {
                !existingIDs.contains($0.id)
            }
            
            movies.append(contentsOf: newMovies)
            
            // MARK: - Update Pagination
            
            currentPage = result.page
            totalPages = result.totalPages
            
            hasMorePages = currentPage < totalPages
            
        } catch is CancellationError {
            
        } catch let error as URLError where error.code == .cancelled {
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Pagination Trigger
    
    func loadMoreIfNeeded(currentItem movie: MovieSummary) async {
        let lastItems = filteredMovies.suffix(6)
        
        guard lastItems.contains(where: { $0.id == movie.id }) else {
            return
        }
        
        await loadNextPage()
    }
    
    // MARK: - Genre Selection
    
    func select(genre: GenreFilter?) {
        selectedGenre = genre
        
        Task { await fillIfNeeded() }
    }
    
    private func fillIfNeeded() async {
        var attempts = 0
        
        while filteredMovies.count < minimumVisibleCount,
              hasMorePages,
              errorMessage == nil,
              attempts < maxAutoLoadPages {
            
            let pageBefore = currentPage
            await loadNextPage()
            
            if currentPage == pageBefore { break }
            attempts += 1
        }
    }
    
    // MARK: - Refresh
    
    func refresh() async {
        guard !isLoading else { return }
        
        let pagesToReload = min(max(currentPage, 1), maxRefreshPages)
        
        movies = []
        currentPage = 0
        totalPages = 1
        hasMorePages = true
        errorMessage = nil
        
        var reloaded = 0
        
        while reloaded < pagesToReload,
              hasMorePages,
              errorMessage == nil {
            
            let pageBefore = currentPage
            await loadNextPage()
            
            if currentPage == pageBefore { break }
            reloaded += 1
        }
        
        await fillIfNeeded()
    }
}
