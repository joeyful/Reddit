//
//  RedditTopListTableViewCell.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

protocol RedditTopListTableViewCellDelegate: class {
    func topListCell(_ cell : RedditTopListTableViewCell, didSelect thumbnail : URL?)
}

class RedditTopListTableViewCell: UITableViewCell {

    weak var delegate : RedditTopListTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel           : UILabel?
    @IBOutlet weak var authorLabel          : UILabel?
    @IBOutlet weak var byLabel              : UILabel?
    @IBOutlet weak var numberOfCommentLabel   : UILabel?
    @IBOutlet weak var dateLabel            : UILabel?
    @IBOutlet weak var thumbnailImageContentView   : ImageContentView?

    override func awakeFromNib() {
        super.awakeFromNib()
        byLabel?.text = NSLocalizedString("by", comment: "by")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String?, author: String?, numberOfComment: String?, date: String?, thumbnailUrl: URL?) {
        titleLabel?.text = title
        authorLabel?.text = author
        numberOfCommentLabel?.text = numberOfComment
        dateLabel?.text = date
        thumbnailImageContentView?.url = thumbnailUrl
    }

}

// MARK: - Action

extension RedditTopListTableViewCell {
    @IBAction func detail(_ button: UIButton) {
        delegate?.topListCell(self, didSelect: thumbnailImageContentView?.url)
    }
}
