//
//  UITableView+AutoSize.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

extension UITableView {
    func autoSize(with estimatedRowHeight: CGFloat = 200) {
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = estimatedRowHeight
    }
}
