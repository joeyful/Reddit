//
//  RedditTopListTableViewCell.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class RedditTopListTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var titleLabel           : UILabel?
    @IBOutlet fileprivate weak var authorLabel          : UILabel?
    @IBOutlet fileprivate weak var numOfCount           : UILabel?
    @IBOutlet fileprivate weak var dateLabel            : UILabel?
    @IBOutlet fileprivate weak var thumbnailImageView   : UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
