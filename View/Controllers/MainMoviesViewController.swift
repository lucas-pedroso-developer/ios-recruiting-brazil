import Foundation
import UIKit
import Kingfisher
import ViewModel
import RxSwift

class MainMoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var page: Int = 1
    var mainMoviesViewModel = MoviesMainViewModel()
    var categoriesViewModel = CategoriesViewModel()
    var moviesArrayFiltered: [[String:String]] = []
    var disposeBag = DisposeBag()
    var genresList: [String] = []    
    var isFinalToLoad : Bool = false
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.genresList.append("Action")
        self.genresList.append("Adventure")
        self.genresList.append("Animation")
        self.genresList.append("Comedy")
        self.genresList.append("Crime")
        
        self.genresList.append("Documentary")
        self.genresList.append("Drama")
        self.genresList.append("Family")
        self.genresList.append("Fantasy")
        self.genresList.append("History")
        
        self.genresList.append("Horror")
        self.genresList.append("Music")
        self.genresList.append("Mystery")
        self.genresList.append("Romance")
        self.genresList.append("Science Fiction")
        
        self.genresList.append("TV Movie")
        self.genresList.append("Thriller")
        self.genresList.append("War")
        self.genresList.append("Western")
        
        setGradient()
        
        self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1")!)
        self.getCategories(url: URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=60471ecf5f288a61c69c6592c9d9e1cf")!)
        
    }
    
    func setGradient() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenSize.height*25/100)
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func getMovies(url: URL) {
        self.mainMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                self.collectionView.reloadData()
                //self.showLoading(false)
            },
            onError: { error in
                //self.showAlert(title: "Erro", message: "Ocorreu o seguinte erro - \(error.localizedDescription) ")
                
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    func getCategories(url: URL) {
        self.categoriesViewModel.getCategories(url: url).subscribe(
            onNext: { result in
                self.categoriesCollectionView.reloadData()
            },
            onError: { error in
                
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            if self.mainMoviesViewModel.moviesMain != nil {
                return (self.mainMoviesViewModel.moviesMain?.results!.count)!
            }
        } else if collectionView.tag == 2 {
            if self.categoriesViewModel.categories != nil {
                return (self.categoriesViewModel.categories?.genres!.count)!
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        if collectionView.tag == 1 {
            cell.label.text = self.mainMoviesViewModel.moviesMain?.results![indexPath.item].title!
            if let url = self.mainMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                cell.image.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
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
            if indexPath.item == (self.mainMoviesViewModel.moviesMain?.results!.count)! - 4 { // - 4 &&
                    if ((self.mainMoviesViewModel.moviesMain?.page)! <= (self.mainMoviesViewModel.moviesMain?.total_pages)!) {
                            self.page = self.page + 1
                            self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=\(self.page)")!)
                    }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            let storyboard = UIStoryboard(name: "Movies", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
            newViewController.type = genresList[indexPath.row]
            newViewController.genreId = (self.categoriesViewModel.categories?.genres![indexPath.item].id!)!
            present(newViewController, animated: true, completion: nil)
        }
        
    }
    
}

