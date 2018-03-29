//
//  RedditViewController.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class RedditViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var tableView : UITableView?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
        
        loadTopRedditList()
    }
}


// MARK: - Helper

fileprivate extension RedditViewController {
    func loadTopRedditList() {
        RedditController.shared.loadTopList(success: {
                self.tableView?.reloadData()
        }, error: { error in
                self.presentAlert(title: NSLocalizedString("Error", comment: "error alert title"), message: error)
        })
    }
}


// MARK: - UITableViewDataSource

extension RedditViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RedditController.shared.listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let reuseIdentifier = card.cardType.rawValue
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedditTopListTableViewCell")
//        if let discoverCell = cell as? DiscoverCardTableViewCell, let discoverCardView = discoverCell.cardView {
//
//            discoverCell.card = card
//            discoverCell.delegate = self
//            discoverCell.cardView?.delegate = self
//
//            registerForPreviewing(with: discoverCardView, sourceView: discoverCardView)
//        }
        
        return cell!
    }
}

