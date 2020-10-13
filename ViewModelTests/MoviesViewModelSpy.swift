import Foundation
import Model
import Infra

public class MoviesMainViewModelSpy {
    public var moviesMain: MoviesMain?
    public var resultsArray: [MoviesResults]?
    
    public var urls = [URL]()
    var data: Data?
    var completion: ((Result<MoviesMain?, HttpError>) -> Void)?
        
    public func getMovies(url: URL, completion: @escaping (Result<MoviesMain?, HttpError>) -> Void) {
        self.urls.append(url)
        self.completion = completion
    }
        
    func completeWithError(_ error: HttpError) {
        completion?(.failure(error))
    }
    
    func completeWithData(_ movies: MoviesMain) {
        completion?(.success(movies))
    }
    
}
