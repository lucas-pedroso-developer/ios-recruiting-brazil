import Foundation
import Model
import Infra
import UIKit
import RxSwift

public class CategoriesViewModel {
        
    public var categories: Categories?
        
    let service = makeHttpService()
    
    public init() { }
    
    public func numberOfRows(collectionView: UICollectionView) -> Int {        
        if self.categories != nil {
            if let count = self.categories?.genres!.count {
                return count
            } 
        }
        return 0
    }
    
    public func cellSize(collectionView: UICollectionView) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
    }
        
    public func getCategories(url: URL) -> Observable<(Result<Categories?, HttpError>)> {
        return Observable.create { observer in
            self.service.get(url: url) { result in
                switch result {
                case .success(let data):
                    if data != nil {
                        do {
                            let results = try JSONDecoder().decode(Categories.self, from: data!)
                                self.categories = results
                                observer.onNext(.success(self.categories))
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

