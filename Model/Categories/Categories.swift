import Foundation

public struct Categories : Model {
    public let genres : [Genres]?

    enum CodingKeys: String, CodingKey {
        case genres = "genres"
    }

    init(genres: [Genres]?) throws {
        self.genres = genres
    }

}
