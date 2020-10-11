import Foundation

struct MoviesResult : Codable {
    let popularity        : Double?
    let vote_count        : Int?
    let video             : Bool?
    let poster_path       : String?
    let id                : Int?
    let adult             : Bool?
    let backdrop_path     : String?
    let original_language : String?
    let original_title    : String?
    let genre_ids         : [Int]?
    let title             : String?
    let vote_average      : Double?
    let overview          : String?
    let release_date      : String?
        
    init(popularity: Double?, vote_count: Int?, video: Bool?, poster_path: String?, id: Int?, adult: Bool?,  backdrop_path: String?, original_language: String?, original_title: String?, genre_ids: [Int]?, title: String?, vote_average: Double?, overview: String?, release_date: String?) {
        self.popularity = popularity
        self.vote_count = vote_count
        self.video = video
        self.poster_path = poster_path
        self.id = id
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.original_language = original_language
        self.original_title = original_title
        self.genre_ids = genre_ids
        self.title = title
        self.vote_average = vote_average
        self.overview = overview
        self.release_date = release_date
    }
    
}
