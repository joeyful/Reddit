//
//  RedditTopListTableViewCell.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class RedditTopListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel           : UILabel?
    @IBOutlet weak var authorLabel          : UILabel?
    @IBOutlet weak var byLabel              : UILabel?
    @IBOutlet weak var numberOfCountLabel   : UILabel?
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

}
