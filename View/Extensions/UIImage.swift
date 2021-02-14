//
//  UIImage.swift
//  View
//
//  Created by Lucas Daniel on 06/02/21.
//  Copyright © 2021 Lucas. All rights reserved.
//

import Foundation
import UIKit
import ViewModel

extension UIImageView {
    func downloadImage(from url: String) {
        guard let urlFromString = URL(string: url) else { return }
        downloadImage(from: urlFromString)
    }

    func downloadImage(from url: URL) {
        ViewModelHelper.downloadImage(url: url) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
