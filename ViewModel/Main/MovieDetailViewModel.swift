import Foundation
import Model
import Infra
import UIKit
import RxSwift

public class MovieDetailViewModel {
    
    public var movieDetail: MovieDetail?
    
    let service = HttpService()
    
    public init() { }
    
    public func getDetail(url: URL) -> Observable<(Result<MovieDetail?, HttpError>)> {
        return Observable.create { observer in
            self.service.get(url: url) { result in
                switch result {
                case .success(let data):
                    if data != nil {
                        do {
                            let results = try JSONDecoder().decode(MovieDetail.self, from: data!)
                                self.movieDetail = results
                                observer.onNext(.success(self.movieDetail))
                        } catch(let error) {
                            observer.onNext(.failure(.noConnectivity))
                        }
                    } else {
                        observer.onNext(.failure(.noConnectivity))
                    }
                case .failure(let error):
                    observer.onNext(.failure(.noConnectivity))
                }
            }
            return Disposables.create()
        }
    }
    
    
}
