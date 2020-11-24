import Foundation
import Model
import Infra
import UIKit
import RxSwift

public class MoviesMainViewModel {
        
    public var resultsArray: [MoviesResult]?
    public var movieToSearch: String = ""
    public var moviesMain: MoviesMain?
    
    let service = makeHttpService()
    
    private(set) var moviesData : MoviesMain! {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    public var bindMoviesViewModelToController : (() -> ()) = { }
    
    public init() { }
    
    public func getMovieId(indexPath: Int) -> Int {
        if let id = self.moviesMain?.results![indexPath].id {
            return id
        }
        return 0
    }
    
    public func getTitle(indexPath: Int) -> String {
        if let title = self.moviesMain?.results![indexPath].title {
            return title
        }
        return "No name"
    }
    
    public func getImage(indexPath: Int) -> URL? {
        if let backdrop_path = self.moviesMain?.results![indexPath].backdrop_path {
            if let url = URL(string: "https://image.tmdb.org/t/p/w500" + backdrop_path) {
                return url
            }
        }
        return nil
    }
    
    public func nextPage(indexPath: IndexPath) -> Bool {
        if indexPath.item == (self.moviesMain?.results!.count)! - 4 {
            if ((self.moviesMain?.page)! <= (self.moviesMain?.total_pages)!) {
                return true
            }
        }
        return false
    }
    
    public func numberOfRows(collectionView: UICollectionView) -> Int {
        if self.moviesMain != nil {
            if let count = self.moviesMain?.results!.count {
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
            self.service.get(url: url) { result in
                switch result {
                case .success(let data):
                    if data != nil {
                        do {
                            let results = try JSONDecoder().decode(MoviesMain.self, from: data!)
                            print(results)
                            if self.moviesMain == nil {
                            //if self.moviesData == nil {
                                self.moviesMain = results
                                //self.moviesData = results
                                observer.onNext(.success(self.moviesMain))
                                //observer.onNext(.success(self.moviesData))
                            } else {
                                self.moviesMain?.results?.append(contentsOf: results.results!)
                                //self.moviesData?.results?.append(contentsOf: results.results!)
                                observer.onNext(.success(self.moviesMain))
                                //observer.onNext(.success(self.moviesData))
                            }
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
