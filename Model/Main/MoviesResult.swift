import Foundation

public struct MoviesResult : Codable {
    public let popularity: Double?
    public let vote_count: Int?
    public let video: Bool?
    public let poster_path: String?
    public let id: Int?
    public let adult: Bool?
    public let backdrop_path: String?
    public let original_language : String?
    public let original_title: String?
    public let genre_ids: [Int]?
    public let title: String?
    public let vote_average: Double?
    public let overview: String?
    public let release_date: String?
        
    public init(popularity: Double?, vote_count: Int?, video: Bool?, poster_path: String?, id: Int?, adult: Bool?,  backdrop_path: String?, original_language: String?, original_title: String?, genre_ids: [Int]?, title: String?, vote_average: Double?, overview: String?, release_date: String?) {
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
