//
//  RedditTopListViewController.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class RedditTopListViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet fileprivate weak var tableView : UITableView?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
        
        loadTopRedditList()
    }
}


// MARK: - Helper

fileprivate extension RedditTopListViewController {
    func loadTopRedditList() {
        RedditController.shared.loadTopList(success: {
                self.tableView?.reloadData()
        }, error: { error in
                self.presentAlert(title: NSLocalizedString("Error", comment: "error alert title"), message: error)
        })
    }
}


// MARK: - UITableViewDataSource

extension RedditTopListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RedditController.shared.listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedditTopListTableViewCell")
        if let topListCell = cell as? RedditTopListTableViewCell, let thumbnailImageContentView = topListCell.thumbnailImageContentView {
            if let list = RedditController.shared.topList {
                let child = list[indexPath.row]
                thumbnailImageContentView.url = child.thumbnail
                topListCell.titleLabel?.text = child.title
                topListCell.authorLabel?.text = child.author
                
                let numComments = child.numComments ?? 0
                topListCell.numberOfCountLabel?.text = "number_of_comments".pluralize(value: numComments)
                
                let createdUTC = child.createdUTC ?? Date()
                topListCell.dateLabel?.text = "\(Date().offsetFrom(createdUTC)) ago"
            }
        }
        
        return cell!
    }
}

