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
        
        tableView?.autoSize()
        tableView?.prefetchDataSource = self
        loadList()
    }
}


// MARK: - Helper

fileprivate extension RedditTopListViewController {
    
    func loadList() {
        RedditController.shared.loadList(success: {
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
        let list = RedditController.shared.list
        if let topListCell = cell as? RedditTopListTableViewCell, indexPath.row < list.count {
                populate(topListCell, with: list[indexPath.row])
        }
        
        return cell!
    }
    
    fileprivate func populate(_ cell: RedditTopListTableViewCell, with child: Child) {
        
        cell.titleLabel?.text = child.title
        cell.authorLabel?.text = child.author
        cell.thumbnailImageContentView?.url = child.thumbnail
        
        let numComments = child.numComments ?? 0
        cell.numberOfCountLabel?.text = "number_of_comments".pluralize(value: numComments)
        
        let createdUTC = child.createdUTC ?? Date()
        cell.dateLabel?.text = "\(Date().offsetFrom(createdUTC)) ago"
    }
}

// MARK: - UITableViewDataSource

extension RedditTopListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let listCount = RedditController.shared.listCount
        let needsFetch = indexPaths.contains { $0.row >= listCount - 1 }
        guard needsFetch else { return }
        
        loadList()
    }
}
