//
//  RedditViewController.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class RedditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        RedditController.shared.top(success: { result in
            guard let result = result.children?.first else { return }
            print("\(result)")
            
        }, error: { error in
            self.presentAlert(title: NSLocalizedString("Error", comment: "error alert title"), message: error)
        })
    }



}

