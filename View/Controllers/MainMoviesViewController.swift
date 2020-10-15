import Foundation
import UIKit
import Kingfisher
import ViewModel
import RxSwift

class MainMoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var page: Int = 1
    var mainMoviesViewModel = MoviesMainViewModel()
    var moviesArrayFiltered: [[String:String]] = []
    var disposeBag = DisposeBag()
    
    var isFinalToLoad : Bool = false
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1")!)
    }
    
    func getMovies(url: URL) {
        self.mainMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                self.collectionView.reloadData()
                
            },
            onError: { error in
                
                
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: screenWidth*42/100, height: screenWidth/2)
    }
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mainMoviesViewModel.moviesMain != nil {
            return (self.mainMoviesViewModel.moviesMain?.results!.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        cell.label.text = self.mainMoviesViewModel.moviesMain?.results![indexPath.item].title!
        
        if let url = self.mainMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
            cell.image.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
        }
        
        cell.backgroundCellView.layer.cornerRadius = UIScreen.main.bounds.width*3/100
        cell.backgroundCellView.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cell.backgroundCellView.layer.borderWidth = 1
        cell.backgroundCellView.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (self.mainMoviesViewModel.moviesMain?.results!.count)! - 4 { // - 4 &&
                if ((self.mainMoviesViewModel.moviesMain?.page)! <= (self.mainMoviesViewModel.moviesMain?.total_pages)!) {
                        self.page = self.page + 1
                        self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=\(self.page)")!)
                }
        }
    }

}

