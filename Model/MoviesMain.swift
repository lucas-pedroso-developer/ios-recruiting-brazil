import Foundation

struct MoviesBase : Codable {
    
    let page : Int?
    let total_results : Int?
    let total_pages : Int?
    let results : [MoviesResult]?
            
    init (page: Int?, total_results : Int?, total_pages : Int?, results : [MoviesResult]?) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        self.results = results
    }
    
}
