import Foundation
import Model
import Infra
import UIKit
import RxSwift

public class MoviesMainViewModel {
        
    public var moviesMain: MoviesMain?
    public var resultsArray: [MoviesResult]?
    public var movieToSearch: String = ""
    
    let service = HttpService()
    
    public init() { }
    
    public func numberOfRows(searchIsActive: Bool) -> Int {
        if searchIsActive {
            var moviesFiltered = self.moviesMain?.results!.filter {
                ($0.title?.contains(self.movieToSearch))!
            }
                                                
            if let filtered = moviesFiltered {
                self.resultsArray = filtered
                return filtered.count
            }
        } else {
            if let array = moviesMain?.results {
                return array.count
            }
        }
        return 0
    }
    
    public func cellSize(collectionView: UICollectionView) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
    }
    
    /*do {
        let results = try JSONDecoder().decode(Pokemons.self, from: data!)
        if self.pokemons == nil {
            self.pokemons = results
            observer.onNext(.success(self.pokemons))
        } else {
            self.pokemons?.next = results.next
            self.pokemons?.results?.append(contentsOf: results.results!)
            observer.onNext(.success(self.pokemons))
        }
    } catch(let error) {
        observer.onNext(.failure(.noConnectivity))
    }*/
    
    public func get(url: URL) -> Observable<(Result<MoviesMain?, HttpError>)> {
        return Observable.create { observer in
            self.service.get(url: url) { result in
                switch result {
                case .success(let data):
                    if data != nil {
                        do {
                            let results = try JSONDecoder().decode(MoviesMain.self, from: data!)
                            if self.moviesMain == nil {
                                self.moviesMain = results
                                observer.onNext(.success(self.moviesMain))
                            } else {
                                self.moviesMain?.results?.append(contentsOf: results.results!)
                                observer.onNext(.success(self.moviesMain))
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
