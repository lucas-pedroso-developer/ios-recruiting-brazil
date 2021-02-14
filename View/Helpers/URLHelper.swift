import Foundation

enum Movies: String {
    case movie = "movie"
    case genre = "genre/movie/list"
    static let movieEnum = [movie, genre]
}

enum MoviesTypeEnum: String {
    case now_playing = "now_playing"
    case popular = "popular"
    case top_rated = "top_rated"
    case upcoming = "upcoming"
}

func buildURL(withPathExtension: String? = nil, page: String? = nil, with_genres: String? = nil, movieId: String? = nil) -> URL? {
    var components = URLComponents()
    components.scheme = Constants.APIScheme
    components.host = Constants.APIHost
    if let id = movieId {        
        components.path = Constants.APIPath + (withPathExtension ?? "") + "/\(id)"
    } else {
        components.path = Constants.APIPath + (withPathExtension ?? "")
    }
    components.queryItems = [URLQueryItem]()
    components.queryItems!.append(URLQueryItem(name: "api_key", value: Constants.APIKey))
    if page != nil {
        components.queryItems!.append(URLQueryItem(name: "page", value: page))
    }
    if with_genres != nil {
        components.queryItems!.append(URLQueryItem(name: "with_genres", value: with_genres))
    }
    return components.url
}
