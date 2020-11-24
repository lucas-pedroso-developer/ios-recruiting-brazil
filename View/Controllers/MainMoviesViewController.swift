import Foundation
import UIKit
import Kingfisher
import ViewModel
import RxSwift

class MainMoviesViewController: UIViewController {
    
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
        self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1")!)
        
        /*self.mainMoviesViewModel.bindMoviesViewModelToController = {
            //print(self.mainMoviesViewModel.moviesData)
            self.collectionView.reloadData()
            //self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1")!)
        }*/
        
        self.getCategories(url: URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=60471ecf5f288a61c69c6592c9d9e1cf")!)
    }
    
    private func setGenresList() {
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
    }
    
    func setGradient() {
        /*let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height*/
        
        //let gradient: CAGradientLayer = CAGradientLayer()
        /*gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenSize.height*25/100)*/
        let gradient = self.makeGradient()
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        
        let gradientTab = self.makeGradient()
        /*gradientTab.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientTab.locations = [0.0 , 1.0]
        gradientTab.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientTab.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientTab.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenSize.height*25/100)*/
        self.tabBarController?.tabBar.layer.insertSublayer(gradientTab, at: 0)
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
            
}

extension MainMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.mainMoviesViewModel.cellSize(collectionView: collectionView)
    }
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return self.mainMoviesViewModel.numberOfRows(collectionView: collectionView)
        } else if collectionView.tag == 2 {
            return self.categoriesViewModel.numberOfRows(collectionView: collectionView)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        if collectionView.tag == 1 {
            cell.label.text = self.mainMoviesViewModel.getTitle(indexPath: indexPath.item)
            if let url = self.mainMoviesViewModel.getImage(indexPath: indexPath.item)  {
                cell.image.kf.setImage(with: url)
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
                self.page = self.page + 1
                self.getMovies(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=\(self.page)")!)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let storyboard = UIStoryboard(name: "Detail", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            newViewController.movieId = self.mainMoviesViewModel.getMovieId(indexPath: indexPath.item)
            present(newViewController, animated: true, completion: nil)
        }
        if collectionView.tag == 2 {
            let storyboard = UIStoryboard(name: "Movies", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
            newViewController.type = genresList[indexPath.row]
            newViewController.genreId = (self.categoriesViewModel.categories?.genres![indexPath.item].id!)!
            present(newViewController, animated: true, completion: nil)
        }
        
    }
}
