import Foundation
import UIKit
import Kingfisher
import ViewModel
import RxSwift

class MoviesViewController: UIViewController {
    
    var typesMovies: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typesMovies = [
            "Novidades",
            "Nos Cinemas",
            "Popular",
            "Top Rated",
            "Lançamentos"
        ]
        
        self.tableView.reloadData()
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
        cell.typesCollectionView.reloadData()
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        
        cell.label.text = "testandooooo"
        cell.image.layer.cornerRadius = UIScreen.main.bounds.width*4/100
        return cell
    }
    
    
}
