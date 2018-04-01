//
//  UIViewController+PresentAlert.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, completion:  (() -> Void)? = nil) {
        
        let okTitle = NSLocalizedString("OK", comment: "Acknowledge error")
        
        let action = UIAlertAction(title: okTitle, style: .default, handler: nil)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: completion)
    }
}
