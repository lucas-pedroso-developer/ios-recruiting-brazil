import Foundation
import UIKit
import ViewModel
import RxSwift

final class MoviesViewController: UIViewController {
    
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
        if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.now_playing)", page: "\(nowPlayingPage)", with_genres: "\(genreId)") {
            getNowPlayingMoviesViewModel(url: url)
        }
    }
    
    private func setGradient() {
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
    
    func getNowPlayingMoviesViewModel(url: URL) {
        nowPlayingMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.popular)", page: "\(self.popularPage)", with_genres: "\(self.genreId)") {
                    self.getPopularMoviesViewModel(url: url)
                }
            },
            onError: { error in
                self.showAlert(title: Constants.erro, message: "\(Constants.error_ocurred)\(error.localizedDescription) ")
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    func getPopularMoviesViewModel(url: URL) {
        self.popularMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.popular)", page: "\(self.topRatedPage)", with_genres: "\(self.genreId)") {
                    self.getTopRatedMoviesViewModel(url: url)
                }
            },
            onError: { error in
                self.showAlert(title: Constants.erro, message: "\(Constants.error_ocurred)\(error.localizedDescription) ")
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }

    
    func getTopRatedMoviesViewModel(url: URL) {
        self.topRatedMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.upcoming)", page: "\(self.upcomingPage)", with_genres: "\(self.genreId)") {
                    self.getUpcomingMoviesViewModel(url: url)
                }
            },
            onError: { error in
                self.showAlert(title: Constants.erro, message: "\(Constants.error_ocurred)\(error.localizedDescription) ")
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }

    
    func getUpcomingMoviesViewModel(url: URL) {
        self.upcomingMoviesViewModel.get(url: url).subscribe(
            onNext: { result in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }                
            },
            onError: { error in
                self.showAlert(title: Constants.erro, message: "\(Constants.error_ocurred)\(error.localizedDescription) ")
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func back(sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        newViewController.genreId = genreId
        newViewController.category = Constants.categories[sender.tag]
        newViewController.type = Constants.typesMovies[sender.tag]
        present(newViewController, animated: true, completion: nil)
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height*30/100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.typesMovies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeViewCell", for: indexPath) as! TypesCollectionViewCell
        cell.typeLabel.text = Constants.typesMovies[indexPath.row]
        cell.typesCollectionView.tag = indexPath.row
        cell.showMoreButton.tag = indexPath.row
        
        row = indexPath.row
                        
        DispatchQueue.main.async {
            cell.typesCollectionView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                return (nowPlayingMoviesViewModel.moviesMain?.results!.count)!
            }
        } else if collectionView.tag == 1 {
            if self.popularMoviesViewModel.moviesMain?.results != nil {
                return (popularMoviesViewModel.moviesMain?.results!.count)!
            }
        } else if collectionView.tag == 2 {
            if self.topRatedMoviesViewModel.moviesMain?.results != nil {
                return (topRatedMoviesViewModel.moviesMain?.results!.count)!
            }
        } else if collectionView.tag == 3 {
            if self.upcomingMoviesViewModel.moviesMain?.results != nil {
                return (upcomingMoviesViewModel.moviesMain?.results!.count)!
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell        
        if collectionView.tag == 0 {
            cell.label.text = self.nowPlayingMoviesViewModel.moviesMain?.results![indexPath.item].title
            if let backdropPath = nowPlayingMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                if let url = URL(string: "\(Constants.APIImage)\(backdropPath)") {
                    cell.image.downloadImage(from: url)
                }
            }
        } else if collectionView.tag == 1 {
            cell.label.text = self.popularMoviesViewModel.moviesMain?.results![indexPath.item].title
            if let backdropPath = popularMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                if let url = URL(string: "\(Constants.APIImage)\(backdropPath)") {
                    cell.image.downloadImage(from: url)
                }
            }
        } else if collectionView.tag == 2 {
            cell.label.text = self.topRatedMoviesViewModel.moviesMain?.results![indexPath.item].title
            if let backdropPath = topRatedMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                if let url = URL(string: "\(Constants.APIImage)\(backdropPath)") {
                    cell.image.downloadImage(from: url)
                }
            }
        } else if collectionView.tag == 3 {
            cell.label.text = self.upcomingMoviesViewModel.moviesMain?.results![indexPath.item].title
            if let backdropPath = upcomingMoviesViewModel.moviesMain?.results![indexPath.item].backdrop_path {
                //if let url = URL(string: "https://image.tmdb.org/t/p/w500" + backdropPath) {
                if let url = URL(string: "\(Constants.APIImage)\(backdropPath)") {
                    cell.image.downloadImage(from: url)
                }
            }
        }
        cell.image.layer.cornerRadius = UIScreen.main.bounds.width*4/100
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            if indexPath.item == (nowPlayingMoviesViewModel.moviesMain?.results!.count)! - 4 {
                if ((nowPlayingMoviesViewModel.moviesMain?.page)! <= (self.nowPlayingMoviesViewModel.moviesMain?.total_pages)!) {
                    nowPlayingPage = self.nowPlayingPage + 1
                    if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.now_playing)", page: "\(nowPlayingPage)", with_genres: "\(genreId)") {
                        getNowPlayingMoviesViewModel(url: url)
                    }
                }
            }
        } else if collectionView.tag == 1 {
            if indexPath.item == (popularMoviesViewModel.moviesMain?.results!.count)! - 4 {
                if ((popularMoviesViewModel.moviesMain?.page)! <= (popularMoviesViewModel.moviesMain?.total_pages)!) {
                    popularPage = self.popularPage + 1
                    if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.popular)", page: "\(self.popularPage)", with_genres: "\(self.genreId)") {
                        self.getPopularMoviesViewModel(url: url)
                    }
                }
            }
        } else if collectionView.tag == 2 {
            if indexPath.item == (topRatedMoviesViewModel.moviesMain?.results!.count)! - 4 {
                if ((topRatedMoviesViewModel.moviesMain?.page)! <= (topRatedMoviesViewModel.moviesMain?.total_pages)!) {
                    topRatedPage = topRatedPage + 1
                    if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.top_rated)", page: "\(self.topRatedPage)", with_genres: "\(self.genreId)") {
                        getTopRatedMoviesViewModel(url: url)
                    }
                }
            }
        } else if collectionView.tag == 3 {
            if indexPath.item == (upcomingMoviesViewModel.moviesMain?.results!.count)! - 4 {
                if ((upcomingMoviesViewModel.moviesMain?.page)! <= (upcomingMoviesViewModel.moviesMain?.total_pages)!) {
                    upcomingPage = upcomingPage + 1
                    if let url = buildURL(withPathExtension: "\(Movies.movie)/\(MoviesTypeEnum.upcoming)", page: "\(self.upcomingPage)", with_genres: "\(self.genreId)") {
                        getUpcomingMoviesViewModel(url: url)
                    }                    
                }
            }
        }
    }
}

