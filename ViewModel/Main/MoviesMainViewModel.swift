import Foundation
import Model
import Infra
import UIKit
import RxSwift

public final class MoviesMainViewModel {
        
    public var resultsArray: [MoviesResult]?
    public var movieToSearch: String = ""
    public var moviesMain: MoviesMain?
            
    private(set) var moviesData : MoviesMain! {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    public var bindMoviesViewModelToController : (() -> ()) = { }
    
    public init() { }
    
    public func getMovieId(indexPath: Int) -> Int {
        if let id = moviesMain?.results?[indexPath].id {
            return id
        }
        return 0
    }
    
    public func getTitle(indexPath: Int) -> String {
        if let title = moviesMain?.results?[indexPath].title {
            return title
        }
        return "No name"
    }
    
    public func getImage(indexPath: Int) -> URL? {
        if let backdrop_path = moviesMain?.results?[indexPath].backdrop_path {
            if let url = URL(string: "https://image.tmdb.org/t/p/w500" + backdrop_path) {
                return url
            }
        }
        return nil
    }
    
    public func nextPage(indexPath: IndexPath) -> Bool {
        if indexPath.item == (moviesMain?.results?.count)! - 4 {
            if ((moviesMain?.page)! <= (moviesMain?.total_pages)!) {
                return true
            }
        }
        return false
    }
    
    public func numberOfRows(collectionView: UICollectionView) -> Int {
        if moviesMain != nil {
            if let count = moviesMain?.results!.count {
                return count
            }
        }
        return 0
    }
    
    public func cellSize(collectionView: UICollectionView) -> CGSize {        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if collectionView.tag == 1 {
            return CGSize(width: screenWidth*34/100, height: screenHeight*30/100)
        } else if collectionView.tag == 2 {
            return CGSize(width: screenWidth*45/100, height: screenHeight*15/100)
        }
        return CGSize(width: 0, height: 0)
    }
        
    public func get(url: URL) -> Observable<(Result<MoviesMain?, HttpError>)> {
        return Observable.create { observer in            
            HttpService.shared.get(url: url) { result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        observer.onNext(.failure(.noConnectivity))
                        return
                    }
                    if let results = ViewModelHelper.decode(modelType: MoviesMain.self, data: data) {
                        self.setMoviesMain(results: results)
                        observer.onNext(.success(self.moviesMain))
                    } else {
                        observer.onNext(.failure(.noConnectivity))
                    }
                case .failure( _):
                    observer.onNext(.failure(.noConnectivity))
                }
            }
            return Disposables.create()
        }
    }
    
    private func setMoviesMain(results: MoviesMain?) {
        if self.moviesMain == nil {
            moviesMain = results
        } else {
            if let result = results?.results {
                moviesMain?.results?.append(contentsOf: result)
            }
        }
    }
     
}
