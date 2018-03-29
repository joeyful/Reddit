//
//  ImageContentView.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class ImageContentView: UIView {
    
    var url : URL? {
        didSet {
            guard url != oldValue else { return }
            loadImage()
        }
    }
    
    fileprivate var image : UIImage? {
        didSet {
            imageView?.image = image
            imageView?.fadeIn()
        }
    }
    
    @IBOutlet fileprivate weak var imageView : UIImageView?
    
    fileprivate func loadImage() {
        guard  let url = url else { return }

        image = nil
        ImageController.shared.fetch(from: url, success: { [weak self] (image) in
            guard url == self?.url else { return }
            self?.image = image
        }) {  (_) in
            // No nothing
        }
    }

}
