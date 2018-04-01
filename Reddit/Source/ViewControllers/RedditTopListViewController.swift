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


    private var offsetIndexPath: IndexPath?
    private let refreshControl = UIRefreshControl()
    private let redditController = RedditController.shared

    // MARK: - Outlets
    
    @IBOutlet private weak var previousButton   : UIButton?
    @IBOutlet private weak var nextButton       : UIButton?
    @IBOutlet private weak var tableView        : UITableView?
    @IBOutlet private weak var loadingGuardView : UIView?
    @IBOutlet private weak var segmentControl   : UISegmentedControl?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
        restoreRedditController()
        
        let direction = Direction(rawValue: UserDefaults.standard.string(forKey: "direction") ?? "none") ?? .none
        loadList(with: direction)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        restoreDetailViewIfNeeded()
    }
    
    // MARK: - State Restoration

    override func encodeRestorableState(with coder: NSCoder) {
                
        coder.encode(redditController.previousPage, forKey: "page")
        coder.encode(redditController.previousAfter, forKey: "after")
        coder.encode(redditController.previousBefore, forKey: "before")
        coder.encode(redditController.direction.rawValue, forKey: "direction")
        coder.encode(segmentControl?.selectedSegmentIndex, forKey: "selectedSegmentIndex")
        
        if let indexPath = tableView?.indexPathsForVisibleRows?.first {
            coder.encode(indexPath.row, forKey: "row")
            UserDefaults.standard.set(indexPath.row, forKey: "row")
        }
        
        UserDefaults.standard.set(redditController.previousPage, forKey: "page")
        UserDefaults.standard.set(redditController.previousAfter, forKey: "after")
        UserDefaults.standard.set(redditController.previousBefore, forKey: "before")
        UserDefaults.standard.set(redditController.direction.rawValue, forKey: "direction")

        super.encodeRestorableState(with: coder)
    }
}

// MARK: - Action

extension RedditTopListViewController {
    @IBAction func previous(_ sender: Any) {
        loadList(with: .before)
    }
    
    @IBAction func next(_ sender: Any) {
        loadList(with: .after)
    }
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "selectedSegmentIndex")
        loadList()
    }
}

// MARK: - Helper

private extension RedditTopListViewController {
    
    @objc func refresh() {
        redditController.reset()
        loadList()
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
        segmentControl?.setTitle(NSLocalizedString("Top 50", comment: "Top 50"), forSegmentAt: 0)
        segmentControl?.setTitle(NSLocalizedString("No Limit", comment: "No Limit"), forSegmentAt: 1)
        segmentControl?.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
    }
    
    func loadList(with direction: Direction = .none) {
        loadingGuardView?.fadeIn()
        refreshControl.endRefreshing()
        redditController.loadList(direction, success: { [weak self] in
            self?.updateUserInterface()
            if let offsetIndexPath = self?.offsetIndexPath, self?.tableView?.numberOfRows(inSection: 0) ?? 0 > 0 {
                self?.offsetIndexPath = nil
                self?.tableView?.scrollToRow(at: offsetIndexPath, at: .top, animated: true)
            }
            
            self?.loadingGuardView?.fadeOut()
        }, error: { [weak self] error in
            self?.presentAlert(title: NSLocalizedString("Error", comment: "error alert title"), message: error)
            self?.loadingGuardView?.fadeOut()
        })
    }
    
    func updateUserInterface() {
        tableView?.reloadData()
        previousButton?.isHidden = (redditController.before == nil) ? true : false
        nextButton?.isHidden = (redditController.before != nil && segmentControl?.selectedSegmentIndex == 0) ? true : false
    }
    
    func restoreDetailViewIfNeeded() {
        guard let url = UserDefaults.standard.url(forKey: "url"),
            let thumbnail = UserDefaults.standard.url(forKey: "thumbnail"),
            UserDefaults.standard.bool(forKey: "isDetailViewVisible") == true else { return }
        
        presentDetailView(url: url, thumbnail: thumbnail)
    }
    
    func presentDetailView(url: URL, thumbnail: URL) {
        if let redditDetailViewController = RedditDetailViewController.buildFromStoryboard() {
            redditDetailViewController.url = url
            redditDetailViewController.thumbnail = thumbnail
            redditDetailViewController.modalTransitionStyle = .crossDissolve
            present(redditDetailViewController, animated: true, completion: nil)
        }
    }
    
    func restoreRedditController() {
        let page = UserDefaults.standard.integer(forKey: "page")
        let after = UserDefaults.standard.string(forKey: "after")
        let before = UserDefaults.standard.string(forKey: "before")
        let direction = Direction(rawValue: UserDefaults.standard.string(forKey: "direction") ?? "none") ?? .none
        let row = UserDefaults.standard.integer(forKey: "row")
        offsetIndexPath = IndexPath(row: row, section: 0)
        redditController.restore(before: before, after: after, page: page, direction: direction)
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
        
        return cell!
    }
    
    private func populate(_ cell: RedditTopListTableViewCell, with child: Child) {
        
        let count = child.numComments ?? 0
        let numberOfComment = "number_of_comments".pluralize(value: count)
        let createdUTC = child.createdUTC ?? Date()
        let date = "\(Date().offsetFrom(createdUTC))" + " " + NSLocalizedString("ago", comment: "ago")
        
        cell.delegate = self
        cell.child = child
        cell.configure(title: child.title, author: child.author, numberOfComment: numberOfComment, date: date, thumbnailUrl: child.thumbnail)
    }
}

// MARK: - RedditTopListTableViewCellDelegate

extension RedditTopListViewController: RedditTopListTableViewCellDelegate {
    func selectedThumbnail(on cell: RedditTopListTableViewCell) {
        guard let url = cell.child?.image?.url, let thumbnail = cell.child?.thumbnail else { return }
        presentDetailView(url: url, thumbnail: thumbnail)
    }
}
