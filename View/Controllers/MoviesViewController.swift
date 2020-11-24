import Foundation
import UIKit
import Kingfisher
import ViewModel
import RxSwift

class MoviesViewController: UIViewController {
    
    var rowTeste: Int = 0
    var row: Int = 0
    var disposeBag = DisposeBag()
    
    var nowPlayingMoviesViewModel = makeMoviesMainViewModel()
    var popularMoviesViewModel = makeMoviesMainViewModel()
    var topRatedMoviesViewModel = makeMoviesMainViewModel()
    var upcomingMoviesViewModel = makeMoviesMainViewModel()
    
    var typesMovies: [String] = []
    var categories: [String] = []
    var type: String = ""
    var genreId: Int = 0
    
    var nowPlayingPage: Int = 1
    var popularPage: Int = 1
    var topRatedPage: Int = 1
    var upcomingPage: Int = 1
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = type
        setGradient()
        self.typesMovies = [
            "Nos Cinemas",
            "Popular",
            "Melhores Avaliados",
            "Lançamentos"
        ]
        
        self.categories = [
            "now_playing",
            "popular",
            "top_rated",
            "upcoming"
        ]
                        
        self.getNowPlayingMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)&page=\(self.nowPlayingPage)")!)
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
    
    func getNowPlayingMoviesViewModel(url: URL) {
        self.nowPlayingMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                self.getPopularMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)&page=\(self.popularPage)")!)
            },
            onError: { error in
                //self.showAlert(title: "Erro", message: "Ocorreu o seguinte erro - \(error.localizedDescription) ")
                print(error.localizedDescription)
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    func getPopularMoviesViewModel(url: URL) {
        self.popularMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                self.getTopRatedMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)&page=\(self.topRatedPage)")!)
            },
            onError: { error in
                //self.showAlert(title: "Erro", message: "Ocorreu o seguinte erro - \(error.localizedDescription) ")
                
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }

    
    func getTopRatedMoviesViewModel(url: URL) {
        self.topRatedMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                self.getUpcomingMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&with_genres=\(self.genreId)&page=\(self.upcomingPage)")!)
            },
            onError: { error in
                //self.showAlert(title: "Erro", message: "Ocorreu o seguinte erro - \(error.localizedDescription) ")
                
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }

    
    func getUpcomingMoviesViewModel(url: URL) {
        self.upcomingMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                self.tableView.reloadData()
            },
            onError: { error in
                //self.showAlert(title: "Erro", message: "Ocorreu o seguinte erro - \(error.localizedDescription) ")
                
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func back(sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        newViewController.genreId = self.genreId
        newViewController.category = self.categories[sender.tag]
        newViewController.type = self.typesMovies[sender.tag]
        present(newViewController, animated: true, completion: nil)
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height*30/100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.typesMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeViewCell", for: indexPath) as! TypesCollectionViewCell
        cell.typeLabel.text = self.typesMovies[indexPath.row]
        cell.typesCollectionView.tag = indexPath.row
        cell.showMoreButton.tag = indexPath.row
        
        self.row = indexPath.row
                        
        DispatchQueue.main.async {
            cell.typesCollectionView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("eae")
    }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        return CGSize(width: screenWidth*34/100, height: screenHeight*25/100)
    }
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            if self.nowPlayingMoviesViewModel.moviesMain?.results != nil {
                return (self.nowPlayingMoviesViewModel.moviesMain?.results!.count)!
            }
        } else if collectionView.tag == 1 {
            if self.popularMoviesViewModel.moviesMain?.results != nil {
                return (self.popularMoviesViewModel.moviesMain?.results!.count)!
            }
        } else if collectionView.tag == 2 {
            if self.topRatedMoviesViewModel.moviesMain?.results != nil {
                return (self.topRatedMoviesViewModel.moviesMain?.results!.count)!
            }
        } else if collectionView.tag == 3 {
            if self.upcomingMoviesViewModel.moviesMain?.results != nil {
                return (self.upcomingMoviesViewModel.moviesMain?.results!.count)!
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        print(collectionView.tag)
        if collectionView.tag == 0 {
            cell.label.text = self.nowPlayingMoviesViewModel.moviesMain?.results![indexPath.item].title
            if let url = self.nowPlayingMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                cell.image.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
            }
        } else if collectionView.tag == 1 {
            cell.label.text = self.popularMoviesViewModel.moviesMain?.results![indexPath.item].title
            if let url = self.popularMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                cell.image.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
            }
        } else if collectionView.tag == 2 {
            cell.label.text = self.topRatedMoviesViewModel.moviesMain?.results![indexPath.item].title
            if let url = self.topRatedMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                cell.image.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
            }
        } else if collectionView.tag == 3 {
            cell.label.text = self.upcomingMoviesViewModel.moviesMain?.results![indexPath.item].title
            if let url = self.upcomingMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                cell.image.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
            }
        }
        cell.image.layer.cornerRadius = UIScreen.main.bounds.width*4/100
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            if indexPath.item == (self.nowPlayingMoviesViewModel.moviesMain?.results!.count)! - 4 {
                if ((self.nowPlayingMoviesViewModel.moviesMain?.page)! <= (self.nowPlayingMoviesViewModel.moviesMain?.total_pages)!) {
                    self.nowPlayingPage = self.nowPlayingPage + 1
                    self.getNowPlayingMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)&page=\(self.nowPlayingPage)")!)
                }
            }
        } else if collectionView.tag == 1 {
            if indexPath.item == (self.popularMoviesViewModel.moviesMain?.results!.count)! - 4 {
                if ((self.popularMoviesViewModel.moviesMain?.page)! <= (self.popularMoviesViewModel.moviesMain?.total_pages)!) {
                    self.popularPage = self.popularPage + 1
                    self.getPopularMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)&page=\(self.popularPage)")!)
                }
            }
        } else if collectionView.tag == 2 {
            if indexPath.item == (self.topRatedMoviesViewModel.moviesMain?.results!.count)! - 4 {
                if ((self.topRatedMoviesViewModel.moviesMain?.page)! <= (self.topRatedMoviesViewModel.moviesMain?.total_pages)!) {
                    self.topRatedPage = self.topRatedPage + 1
                    self.getTopRatedMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)&page=\(self.topRatedPage)")!)
                }
            }
        } else if collectionView.tag == 3 {
            if indexPath.item == (self.upcomingMoviesViewModel.moviesMain?.results!.count)! - 4 {
                if ((self.upcomingMoviesViewModel.moviesMain?.page)! <= (self.upcomingMoviesViewModel.moviesMain?.total_pages)!) {
                    self.upcomingPage = self.upcomingPage + 1
                    self.getUpcomingMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)&page=\(self.upcomingPage)")!)
                }
            }
        }
    }
}

