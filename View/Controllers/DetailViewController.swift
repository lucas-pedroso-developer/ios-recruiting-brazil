import Foundation
import UIKit
import ViewModel
import RxSwift
import Kingfisher

class DetailViewController: UIViewController {
    
    var movieId: Int?
    var movieDetailViewModel = MovieDetailViewModel()
    var disposeBag = DisposeBag()
    var genres: [String] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var synopseTextView: UITextView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        self.getMovieDetail(url: URL(string: "https://api.themoviedb.org/3/movie/\(movieId!)?api_key=60471ecf5f288a61c69c6592c9d9e1cf")!)
        
    }
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = self.navigationBar.bounds
        updatedFrame.size.height += UIApplication.shared.statusBarFrame.size.height
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Horizontal gradient start
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0) // Horizontal gradient end
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }
    
    func getMovieDetail(url: URL) {
        self.movieDetailViewModel.getDetail(url: url).subscribe(
            onNext: { result in
                //self.collectionView.reloadData()
                self.titleLabel.text = self.movieDetailViewModel.movieDetail?.title!
                self.synopseTextView.text = self.movieDetailViewModel.movieDetail?.overview!
                if let url = self.movieDetailViewModel.movieDetail?.backdrop_path {
                    self.movieImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
                }
                if let genres = self.movieDetailViewModel.movieDetail?.genres {
                    for genre in genres {
                        self.genres.append(genre.name!)
                    }
                }
                self.collectionView.reloadData()
                
            },
            onError: { error in
                //self.showAlert(title: "Erro", message: "Ocorreu o seguinte erro - \(error.localizedDescription) ")
                print(error.localizedDescription)
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        return CGSize(width: screenWidth*12/100, height: screenHeight*27/100)
    }*/
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GenresCell
        cell.nameLabel.text = self.genres[indexPath.item]
        cell.nameLabel.layer.borderColor = UIColor.black.cgColor
        cell.nameLabel.layer.borderWidth = 1
        cell.nameLabel.layer.cornerRadius = 5
        return cell
    }
    
    
    
}

