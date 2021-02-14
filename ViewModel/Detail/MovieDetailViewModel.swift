import Foundation
import Model
import Infra
import UIKit
import RxSwift

public final class MovieDetailViewModel {
    
    public var movieDetail: MovieDetail?
            
    public init() { }
    
    public func getDetail(url: URL) -> Observable<(Result<MovieDetail?, HttpError>)> {
        return Observable.create { observer in
            
            HttpService.shared.get(url: url) { result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        observer.onNext(.failure(.noConnectivity))
                        return
                    }
                    let results = ViewModelHelper.decode(modelType: MovieDetail.self, data: data)
                    self.movieDetail = results
                    observer.onNext(.success(self.movieDetail))                    
                case .failure(let _):
                    observer.onNext(.failure(.noConnectivity))
                }
            }
            return Disposables.create()
        }
    }
    
    
}
