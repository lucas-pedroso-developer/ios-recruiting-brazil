import Foundation

public struct MovieDetail: Model {        
    public let backdrop_path: String?
    public let genres: [MovieGenres]?
    public let homepage: String?
    public let id: Int?
    public let original_title: String?
    public let overview: String?
    public let poster_path: String?
    public let release_date: String?
    public let title: String?
    public let vote_average: Double?
    
    public init(backdrop_path: String?, genres: [MovieGenres]?, homepage: String?, id: Int?, original_title: String?, overview: String?, poster_path: String?, release_date: String?, title: String?, vote_average: Double?) {
        self.backdrop_path = backdrop_path
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.original_title = original_title
        self.overview = overview
        self.poster_path = poster_path
        self.release_date = release_date
        self.title = title
        self.vote_average = vote_average
    }
}
