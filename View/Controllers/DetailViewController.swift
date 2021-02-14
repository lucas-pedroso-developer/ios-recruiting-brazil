import Foundation
import UIKit
import ViewModel
import RxSwift

final class DetailViewController: UIViewController {
    
    var movieId: Int?
    var movieDetailViewModel = makeMovieDetailViewModel()
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
        if let id = movieId {
            if let url = buildURL(withPathExtension: "\(Movies.movie)", movieId: "\(id)") {
                getMovieDetail(url: url)
            }
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
    
    func getMovieDetail(url: URL) {
        movieDetailViewModel.getDetail(url: url).subscribe(
            onNext: { result in
                DispatchQueue.main.async {
                    self.titleLabel.text = self.movieDetailViewModel.movieDetail?.title!
                    self.synopseTextView.text = self.movieDetailViewModel.movieDetail?.overview!
                    if let url = self.movieDetailViewModel.movieDetail?.backdrop_path {
                        self.movieImageView.downloadImage(from: url)
                    }
                    if let genres = self.movieDetailViewModel.movieDetail?.genres {
                        for genre in genres {
                            self.genres.append(genre.name!)
                        }
                    }
                    self.collectionView.reloadData()
                }
            },
            onError: { error in
                self.showAlert(title: Constants.erro, message: "\(Constants.error_ocurred) \(error.localizedDescription) ")
            },
            onCompleted: { }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GenresCell
        cell.nameLabel.text = genres[indexPath.item]
        cell.nameLabel.layer.borderColor = UIColor.black.cgColor
        cell.nameLabel.layer.borderWidth = 1
        cell.nameLabel.layer.cornerRadius = 5
        return cell
    }    
}

