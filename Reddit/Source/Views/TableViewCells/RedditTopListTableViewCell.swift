//
//  RedditTopListTableViewCell.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

protocol RedditTopListTableViewCellDelegate: class {
    func selectedThumbnail(on cell: RedditTopListTableViewCell)
}

class RedditTopListTableViewCell: UITableViewCell {

    var child: Child?
    weak var delegate : RedditTopListTableViewCellDelegate?
    
    // MARK: - Outlets

    @IBOutlet weak var titleLabel           : UILabel?
    @IBOutlet weak var authorLabel          : UILabel?
    @IBOutlet weak var byLabel              : UILabel?
    @IBOutlet weak var numberOfCommentLabel   : UILabel?
    @IBOutlet weak var dateLabel            : UILabel?
    @IBOutlet weak var thumbnailImageContentView   : ImageContentView?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        byLabel?.text = NSLocalizedString("by", comment: "by")
    }
    
    // MARK: - Pubilc Function

    func configure(title: String?, author: String?, numberOfComment: String?, date: String?, thumbnailUrl: URL?) {
        titleLabel?.text = title
        authorLabel?.text = author
        numberOfCommentLabel?.text = numberOfComment
        dateLabel?.text = date
        thumbnailImageContentView?.url = thumbnailUrl
    }

    // MARK: - Action

    @IBAction func detail(_ button: UIButton) {
        guard "default" != child?.thumbnail?.absoluteString else { return }
        delegate?.selectedThumbnail(on: self)
    }
}
