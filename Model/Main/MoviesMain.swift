import Foundation

public struct MoviesMain : Codable {
    public let page : Int?
    public let total_results : Int?
    public let total_pages : Int?
    public let results : [MoviesResult]?
            
    public init (page: Int?, total_results : Int?, total_pages : Int?, results : [MoviesResult]?) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        self.results = results
    }    
}
