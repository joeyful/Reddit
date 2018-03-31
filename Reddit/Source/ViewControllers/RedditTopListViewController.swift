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

    var index: IndexPath?
    
    private let refreshControl = UIRefreshControl()
    private let redditController = RedditController.shared

    // MARK: - Outlets
    
    @IBOutlet private weak var previousButton   : UIButton?
    @IBOutlet private weak var nextButton       : UIButton?

    @IBOutlet private weak var tableView        : UITableView?
    @IBOutlet private weak var loadingGuardView : UIView?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
        if UserDefaults.standard.bool(forKey: "isStartFromRestoration") == false  {
            loadList(.none)
        }
    }

    // MARK: - State Restoration

    override func encodeRestorableState(with coder: NSCoder) {
        
        UserDefaults.standard.set(true, forKey: "isStartFromRestoration")
        
        coder.encode(redditController.previousPage, forKey: "page")
        coder.encode(redditController.previousAfter, forKey: "after")
        coder.encode(redditController.previousBefore, forKey: "before")
        coder.encode(redditController.direction.rawValue, forKey: "direction")

        if let index = tableView?.indexPathsForVisibleRows?.first {
            coder.encode(index, forKey: "index")
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        let page = coder.decodeInteger(forKey: "page")
        let after = coder.decodeObject(forKey: "after") as? String
        let before = coder.decodeObject(forKey: "before") as? String
        
        var direction = Direction.none
        if let rawValue = coder.decodeObject(forKey: "direction") as? String {
            direction = Direction(rawValue: rawValue) ?? .none
        }
        redditController.restore(before: before, after: after, page: page, direction: direction)

        index = coder.decodeObject(forKey: "index") as? IndexPath

        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        UserDefaults.standard.set(false, forKey: "isStartFromRestoration")
        loadList(redditController.direction)
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

private extension RedditTopListViewController {
    
    @objc func refresh() {
        redditController.reset()
        loadList(.none)
    }
    
    func addRefreshControl() {
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView?.refreshControl = refreshControl
    }
    
    func setupUserInterface() {
        previousButton?.setTitle(NSLocalizedString("Prev", comment: "previous"), for: .normal)
        nextButton?.setTitle(NSLocalizedString("Next", comment: "next"), for: .normal)
        addRefreshControl()
        tableView?.autoSize()
    }
    
    func loadList(_ direction: Direction) {
        loadingGuardView?.fadeIn()
        refreshControl.endRefreshing()
        redditController.loadList(direction, success: { [weak self] in
            self?.tableView?.reloadData()
            self?.previousButton?.isHidden = self?.redditController.before == nil ? true : false
            self?.loadingGuardView?.fadeOut()
        }, error: { [weak self] error in
            self?.presentAlert(title: NSLocalizedString("Error", comment: "error alert title"), message: error)
            self?.loadingGuardView?.fadeOut()
        })
    }
}


// MARK: - UITableViewDataSource

extension RedditTopListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditController.listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedditTopListTableViewCell")
        let list = redditController.list
        if let topListCell = cell as? RedditTopListTableViewCell, indexPath.row < list.count {
            let child = list[indexPath.row]
            populate(topListCell, with: child)
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: 0) {
            tableView.scrollToRow(at: index!, at: .top, animated: true)
        }
        
        return cell!
    }
    
    private func populate(_ cell: RedditTopListTableViewCell, with child: Child) {
        
        let count = child.numComments ?? 0
        let numberOfComment = "number_of_comments".pluralize(value: count)
        let createdUTC = child.createdUTC ?? Date()
        let date = "\(Date().offsetFrom(createdUTC))" + NSLocalizedString("ago", comment: "ago")
        cell.configure(title: child.title, author: child.author, numberOfComment: numberOfComment, date: date, thumbnailUrl: child.thumbnail)
        
        cell.delegate = self
        cell.child = child
    }
}

// MARK: - RedditTopListTableViewCellDelegate

extension RedditTopListViewController: RedditTopListTableViewCellDelegate {
    func didSelectTopListCell(_ cell: RedditTopListTableViewCell) {
        
        if let redditDetailViewController = RedditDetailViewController.buildFromStoryboard() {
            guard let url = cell.child?.image?.url, let thumbnail = cell.child?.thumbnail else { return }
            
            redditDetailViewController.url = url
            redditDetailViewController.thumbnail = thumbnail
            redditDetailViewController.modalTransitionStyle = .crossDissolve
            present(redditDetailViewController, animated: true, completion: nil)
        }
    }
}
