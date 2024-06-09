//
//  DisplayMessage.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit

extension UIViewController {
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
         preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
         handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
