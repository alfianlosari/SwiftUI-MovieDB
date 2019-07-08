import Foundation
import Combine

protocol MovieService {    
    func fetchMovies(from endpoint: Endpoint, params: [String: String]?) -> AnyPublisher<MoviesResponse, Error>
    func fetchMovie(id: Int) -> AnyPublisher<Movie, Error>
    func searchMovie(query: SearchQuery, params: [String : String]?) -> AnyPublisher<MoviesResponse, Error>
}

struct SearchQuery {
    let language: Locale = Locale.current
    let allowAdult: Bool = false
    let textQuery: String

    var parameters: [String: String] {
        return [
            "language": self.language.identifier,
            "include_adult": self.allowAdult ? "true" : "false",
            "region": self.language.regionCode ?? "FR",
            "query": self.textQuery
        ]
    }
}

public enum Endpoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case popular
    case topRated = "top_rated"
    
    public var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        }
    }
    
    public init?(index: Int) {
        switch index {
        case 0: self = .nowPlaying
        case 1: self = .popular
        case 2: self = .upcoming
        case 3: self = .topRated
        default: return nil
        }
    }
    
    public init?(description: String) {
        guard let first = Endpoint.allCases.first(where: { $0.description == description }) else {
            return nil
        }
        self = first
    }
}

public enum MovieError: Error {
    case apiError(Error)
    case invalidEndpoint(URL)
    case invalidParameters([String: String])
    case invalidResponse(URLResponse?)
    case noData
    case serializationError(Error)
}

