//
//  UIViewController.swift
//  View
//
//  Created by Lucas Daniel on 06/02/21.
//  Copyright © 2021 Lucas. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
