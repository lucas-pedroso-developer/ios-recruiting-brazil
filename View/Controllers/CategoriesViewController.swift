import Foundation
import UIKit
import ViewModel
import RxSwift

final class CategoriesViewController: UIViewController {
    
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
        if let url = buildURL(withPathExtension: "\(Movies.movie)/\(category)", page: "1", with_genres: "\(self.genreId)") {
            getMovies(url: url)
        }
    }
    
    func setGradient() {
        let gradientLayer = makeGradient()
        var updatedFrame = navigationBar.bounds
        updatedFrame.size.height += UIApplication.shared.statusBarFrame.size.height
        gradientLayer.frame = updatedFrame
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }
    
    func getMovies(url: URL) {
        moviesViewModel.get(url: url).subscribe(
            onNext: { result in
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }                
            },
            onError: { error in
                self.showAlert(title: Constants.erro, message: "\(Constants.error_ocurred) \(error.localizedDescription) ")
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        if moviesViewModel.moviesMain != nil {
            return (moviesViewModel.moviesMain?.results!.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
            cell.label.text = moviesViewModel.moviesMain?.results![indexPath.item].title!
            if let backdropPath = moviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                if let url = URL(string: "\(Constants.APIImage)\(backdropPath)") {
                    cell.image.downloadImage(from: url)
                }
            }
            cell.image.layer.cornerRadius = UIScreen.main.bounds.width*3/100
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.item == (moviesViewModel.moviesMain?.results!.count)! - 4 { // - 4 &&
                    if ((moviesViewModel.moviesMain?.page)! <= (moviesViewModel.moviesMain?.total_pages)!) {
                            page = page + 1                        
                        if let url = buildURL(withPathExtension: "\(Movies.movie)/\(category)", page: "\(page)") {
                            getMovies(url: url)
                        }
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
