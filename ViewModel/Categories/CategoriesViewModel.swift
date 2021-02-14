import Foundation
import Model
import Infra
import UIKit
import RxSwift

public final class CategoriesViewModel {
        
    public var categories: Categories?
               
    public init() { }
    
    public func numberOfRows(collectionView: UICollectionView) -> Int {        
        if self.categories != nil {
            if let count = categories?.genres?.count {
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
            HttpService.shared.get(url: url) { result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        observer.onNext(.failure(.noConnectivity))
                        return
                    }
                    let results = ViewModelHelper.decode(modelType: Categories.self, data: data)
                    self.categories = results
                    observer.onNext(.success(self.categories))
                case .failure(let _):
                    observer.onNext(.failure(.noConnectivity))
                }
            }
            return Disposables.create()
        }
    }
 
}

