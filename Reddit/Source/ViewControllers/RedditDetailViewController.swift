//
//  RedditDetailViewController.swift
//  Reddit
//
//  Created by Joey Wei on 3/30/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class RedditDetailViewController: UIViewController {

    var thumbnail: URL?
    
    class func buildFromStoryboard() -> RedditDetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let redditDetailViewController = storyboard.instantiateViewController(withIdentifier:  "RedditDetailVC") as? RedditDetailViewController else { return nil }
        return  redditDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
