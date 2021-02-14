import Foundation

struct Constants {
    static let APIScheme = "https"
    static let APIHost = "api.themoviedb.org"
    static let APIPath = "/3/"
    static let APIKey = "60471ecf5f288a61c69c6592c9d9e1cf"
    
    static let APIImage = "https://image.tmdb.org/t/p/w500"
    
    static let erro = "Erro"
    static let error_ocurred = "Ocorreu o seguinte erro - "
    
    static let typesMovies = ["Nos Cinemas", "Popular", "Melhores Avaliados", "Lançamentos"]    
    static let categories = ["now_playing", "popular", "top_rated", "upcoming"]
}
//if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.upcoming)", page: "1") {
//if let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=60471ecf5f288a61c69c6592c9d9e1cf") {
