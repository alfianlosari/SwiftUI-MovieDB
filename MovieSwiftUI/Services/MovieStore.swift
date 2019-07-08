import Foundation
import Combine

public class MovieStore: MovieService {
    
    public static let shared = MovieStore()
    private init() {}
    private let apiKey = "ce80e633bf37b736ca6668ae476c7465"
    private let baseAPIURL = URL(string: "https://api.themoviedb.org/3")!
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()

    public func fetchMovies(from endpoint: Endpoint, params: [String: String]? = nil) -> AnyPublisher<MoviesResponse, Error> {
        do {
            let url = try self.formURL(pathComponents: ["movie", endpoint.rawValue], parameters: params)

            return urlSession.dataTaskPublisher(for: url)
                .tryFilter(filterPublishedReturn)
                .map { data, _ in data }
                .decode(type: MoviesResponse.self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
        } catch {
            return Publishers.Fail(outputType: MoviesResponse.self, failure: error).eraseToAnyPublisher()
        }
    }

    public func fetchMovie(id: Int) -> AnyPublisher<Movie, Error> {
        do {
            let url = try formURL(pathComponents: ["movie", "\(id)"], parameters: ["append_to_response": "videos,credits"])

            return urlSession.dataTaskPublisher(for: url)
                .tryFilter(filterPublishedReturn)
                .map { data, _ in data }
                .decode(type: Movie.self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
        } catch {
            return Publishers.Fail(outputType: Movie.self, failure: error).eraseToAnyPublisher()
        }
    }

    func searchMovie(query: SearchQuery, params: [String : String]?) -> AnyPublisher<MoviesResponse, Error> {
        do {
            let url = try formURL(pathComponents: ["search", "movie"], parameters: query.parameters)

            return urlSession.dataTaskPublisher(for: url)
                .tryFilter(filterPublishedReturn)
                .map { data, _ in data }
                .decode(type: MoviesResponse.self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
        } catch {
            return Publishers.Fail(outputType: MoviesResponse.self, failure: error).eraseToAnyPublisher()
        }
    }

    private func formURL(pathComponents: [String], parameters: [String: String]? = nil) throws -> URL {
        let endpointURL = pathComponents.reduce(baseAPIURL) { url, component in
            url.appendingPathComponent(component)
        }

        guard var urlComponents = URLComponents(url: endpointURL, resolvingAgainstBaseURL: true) else {
            throw MovieError.invalidEndpoint(endpointURL)
        }

        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let parameters = parameters {
            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw MovieError.invalidParameters(parameters ?? [:])
        }

        return url
    }

    private func filterPublishedReturn(data: Data, response: URLResponse) throws -> Bool {
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw MovieError.invalidResponse(response)
        }
        return true
    }
}
