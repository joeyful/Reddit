//
//  RedditTopListViewController.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

enum Direction: String { case after = "after", before = "before", none = "none" }


class RedditTopListViewController: UIViewController {

    fileprivate let refreshControl = UIRefreshControl()

    // MARK: - Outlets
    @IBOutlet fileprivate weak var previousButton   : UIButton?
    @IBOutlet fileprivate weak var nextButton       : UIButton?

    @IBOutlet fileprivate weak var tableView        : UITableView?
    @IBOutlet fileprivate weak var loadingGuardView : UIView?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousButton?.setTitle(NSLocalizedString("Prev", comment: "previous"), for: .normal)
        nextButton?.setTitle(NSLocalizedString("Next", comment: "next"), for: .normal)

        addRefreshControl()
        tableView?.autoSize()
        if UserDefaults.standard.bool(forKey: "isStartFromRestoration") == false  {
            loadList(.none)
        }
    }

    // MARK: - State Restoration

    override func encodeRestorableState(with coder: NSCoder) {
        
        UserDefaults.standard.set(true, forKey: "isStartFromRestoration")
        
        let redditController = RedditController.shared
        coder.encode(redditController.oldPage, forKey: "page")
        coder.encode(redditController.oldAfter, forKey: "after")
        coder.encode(redditController.oldBefore, forKey: "before")
        coder.encode(redditController.direction.rawValue, forKey: "direction")

        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        let redditController = RedditController.shared

        redditController.page = coder.decodeInteger(forKey: "page")
        redditController.after = coder.decodeObject(forKey: "after") as? String
        redditController.before = coder.decodeObject(forKey: "before") as? String
        
        if let direction = coder.decodeObject(forKey: "direction") as? String {
            redditController.direction = Direction(rawValue: direction) ?? .none
        }
        
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        UserDefaults.standard.set(false, forKey: "isStartFromRestoration")
        loadList(RedditController.shared.direction)
    }
}

// MARK: - Action

extension RedditTopListViewController {
    @IBAction func previous(_ sender: Any) {
        loadList(.before)
    }
    
    @IBAction func next(_ sender: Any) {
        loadList(.after)
    }
}

// MARK: - Helper

fileprivate extension RedditTopListViewController {
    
    @objc func refresh() {
        RedditController.shared.reset()
        loadList(.none)
    }
    
    func addRefreshControl() {
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        tableView?.refreshControl = refreshControl
    }
    
    func loadList(_ direction: Direction) {
        loadingGuardView?.fadeIn()
        self.refreshControl.endRefreshing()
        RedditController.shared.loadList(direction, success: {
                self.tableView?.reloadData()
                self.previousButton?.isHidden = RedditController.shared.before == nil ? true : false
                self.loadingGuardView?.fadeOut()

        }, error: { error in
                self.presentAlert(title: NSLocalizedString("Error", comment: "error alert title"), message: error)
                self.loadingGuardView?.fadeOut()
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
