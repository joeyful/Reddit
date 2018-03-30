//
//  String+Pluralization.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

extension String {
    func pluralize(value: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString(self, comment: ""), value)
    }
}
