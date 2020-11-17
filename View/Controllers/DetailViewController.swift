import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var movieId: Int = 0
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var synopseTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
