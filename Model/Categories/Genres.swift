import Foundation

public struct Genres : Model {
    public let id : Int?
    public let name : String?

    public init(id: Int?, name: String) throws {
        self.id = id
        self.name = name
    }

}
