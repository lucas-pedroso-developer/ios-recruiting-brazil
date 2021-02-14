import Foundation
import UIKit
import ViewModel
import RxSwift

final class MainMoviesViewController: UIViewController {
    
    var page: Int = 1
    var mainMoviesViewModel = makeMoviesMainViewModel()
    var categoriesViewModel = makeCategoriesViewModelFactory()
    var moviesArrayFiltered: [[String:String]] = []
    var disposeBag = DisposeBag()
    var genresList: [String] = []    
    var isFinalToLoad : Bool = false
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setGenresList()
        setGradient()
        
        if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.upcoming)", page: "1") {
            getMovies(url: url)
        }
        
        if let url = buildURL(withPathExtension: Movies.genre.rawValue) {            
            getCategories(url: url)
        }
    }
    
    private func setGenresList() {
        genresList.append("Action")
        genresList.append("Adventure")
        genresList.append("Animation")
        genresList.append("Comedy")
        genresList.append("Crime")
        genresList.append("Documentary")
        genresList.append("Drama")
        genresList.append("Family")
        genresList.append("Fantasy")
        genresList.append("History")
        genresList.append("Horror")
        genresList.append("Music")
        genresList.append("Mystery")
        genresList.append("Romance")
        genresList.append("Science Fiction")
        genresList.append("TV Movie")
        genresList.append("Thriller")
        genresList.append("War")
        genresList.append("Western")
    }
    
    func setGradient() {
        let gradient = makeGradient()
        let gradientTab = makeGradient()
        gradientView.layer.insertSublayer(gradient, at: 0)
        tabBarController?.tabBar.layer.insertSublayer(gradientTab, at: 0)
    }
    
    func getMovies(url: URL) {
        mainMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            },
            onError: { error in
                self.showAlert(title: Constants.erro, message: "\(Constants.error_ocurred)")
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    func getCategories(url: URL) {
        categoriesViewModel.getCategories(url: url).subscribe(
            onNext: { result in
                DispatchQueue.main.async {
                    self.categoriesCollectionView.reloadData()
                }
            },
            onError: { error in
                
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
  
}

extension MainMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        mainMoviesViewModel.cellSize(collectionView: collectionView)
    }
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return mainMoviesViewModel.numberOfRows(collectionView: collectionView)
        } else if collectionView.tag == 2 {
            return categoriesViewModel.numberOfRows(collectionView: collectionView)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        if collectionView.tag == 1 {
            cell.label.text = self.mainMoviesViewModel.getTitle(indexPath: indexPath.item)
            if let url = self.mainMoviesViewModel.getImage(indexPath: indexPath.item)  {
                cell.image.downloadImage(from: url)
            }
            cell.image.layer.cornerRadius = UIScreen.main.bounds.width*3/100
        } else if collectionView.tag == 2 {
            cell.label.text = self.categoriesViewModel.categories?.genres![indexPath.item].name!
            cell.backgroundCellView.layer.cornerRadius = UIScreen.main.bounds.width*4/100
            cell.image.image = UIImage(named: self.genresList[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if self.mainMoviesViewModel.nextPage(indexPath: indexPath) {
                page = page + 1                
                if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.upcoming)", page: "\(self.page)") {
                    getMovies(url: url)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let storyboard = UIStoryboard(name: "Detail", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            newViewController.movieId = mainMoviesViewModel.getMovieId(indexPath: indexPath.item)
            present(newViewController, animated: true, completion: nil)
        }
        if collectionView.tag == 2 {
            let storyboard = UIStoryboard(name: "Movies", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
            newViewController.type = genresList[indexPath.row]
            newViewController.genreId = (categoriesViewModel.categories?.genres![indexPath.item].id!)!
            present(newViewController, animated: true, completion: nil)
        }
        
    }
}
