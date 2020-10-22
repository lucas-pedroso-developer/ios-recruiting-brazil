import Foundation
import UIKit
import Kingfisher
import ViewModel
import RxSwift

class MoviesViewController: UIViewController {
    
    var rowTeste: Int = 0
    var row: Int = 0
    var disposeBag = DisposeBag()
    
    var nowPlayingMoviesViewModel = MoviesMainViewModel()
    var popularMoviesViewModel = MoviesMainViewModel()
    var topRatedMoviesViewModel = MoviesMainViewModel()
    var upcomingMoviesViewModel = MoviesMainViewModel()
    
    var typesMovies: [String] = []
    var type: String = ""
    var genreId: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = type
        self.typesMovies = [
            "Nos Cinemas",
            "Popular",
            "Top Rated",
            "Lançamentos"
        ]
        
        self.getNowPlayingMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)")!)
    }
    
    func getNowPlayingMoviesViewModel(url: URL) {
        self.nowPlayingMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                self.getPopularMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)")!)
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
                self.getTopRatedMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)")!)
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
                self.getUpcomingMoviesViewModel(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=60471ecf5f288a61c69c6592c9d9e1cf&page=1&with_genres=\(self.genreId)")!)
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
                
        self.row = indexPath.row
                        
        DispatchQueue.main.async {
            cell.typesCollectionView.reloadData()
        }
        
        return cell
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
    
        
}

