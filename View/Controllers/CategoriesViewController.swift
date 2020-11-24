import Foundation
import UIKit
import Kingfisher
import ViewModel
import RxSwift


class CategoriesViewController: UIViewController {
    
    var page: Int = 0
    var category: String = ""
    var type: String = ""
    var genreId: Int = 0
    var disposeBag = DisposeBag()
    var moviesViewModel = makeMoviesMainViewModel()
            
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = type
        setGradient()
        self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/\(category)?api_key=60471ecf5f288a61c69c6592c9d9e1cf&with_genres=\(self.genreId)&page=1")!)
        
    }
    
    func setGradient() {
        let gradientLayer = makeGradient()
        var updatedFrame = self.navigationBar.bounds
        updatedFrame.size.height += UIApplication.shared.statusBarFrame.size.height
        gradientLayer.frame = updatedFrame
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }
    
    func getMovies(url: URL) {
        self.moviesViewModel.get(url: url).subscribe(
            onNext: { result in
                self.collectionView.reloadData()
            },
            onError: { error in
                //self.showAlert(title: "Erro", message: "Ocorreu o seguinte erro - \(error.localizedDescription) ")
                print(error.localizedDescription)
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        return CGSize(width: screenWidth*36/100, height: screenHeight*27/100)
    }
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.moviesViewModel.moviesMain != nil {
            return (self.moviesViewModel.moviesMain?.results!.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
            cell.label.text = self.moviesViewModel.moviesMain?.results![indexPath.item].title!
            if let url = self.moviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                cell.image.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
            }
            cell.image.layer.cornerRadius = UIScreen.main.bounds.width*3/100
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.item == (self.moviesViewModel.moviesMain?.results!.count)! - 4 { // - 4 &&
                    if ((self.moviesViewModel.moviesMain?.page)! <= (self.moviesViewModel.moviesMain?.total_pages)!) {
                            self.page = self.page + 1
                            self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=\(self.page)")!)
                    }
            }        
    }
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            let storyboard = UIStoryboard(name: "Movies", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
            newViewController.type = genresList[indexPath.row]
            newViewController.genreId = (self.categoriesViewModel.categories?.genres![indexPath.item].id!)!
            present(newViewController, animated: true, completion: nil)
        }
    }*/
    
}
