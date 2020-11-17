import Foundation

public struct MovieDetail: Model {
    let backdrop_path: String?
    let genres: [Genres]?
    let homepage: String?
    let id: Int?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let vote_average: Double?
    
    public init() {
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
