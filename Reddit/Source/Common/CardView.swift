//
//  CardView.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    @IBInspectable var shadowed = true {
        didSet {
            if shadowed {
                showShadow()
            }
            else {
                hideShadow()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shouldRasterize = true;
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 8.0
        
        if shadowed {
            showShadow()
        }
        else {
            hideShadow()
        }
    }
    
    
}
