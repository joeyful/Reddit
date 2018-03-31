//
//  ImageContentView.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

protocol ImageContentViewDelegate: class {
    func imageLoaded(_ image: UIImage)
    func failLoading(_ error: String)
}

class ImageContentView: UIView {

    weak var delegate: ImageContentViewDelegate?
    
    var url : URL? {
        didSet {
            guard url != oldValue else { return }
            loadImage()
        }
    }
    
    var image : UIImage? {
        didSet {
            guard image != oldValue else { return }
            imageView?.image = image
            imageView?.fadeIn()
        }
    }

    // MARK: - Outlets

    @IBOutlet private weak var imageView : UIImageView?
}


// MARK: - Private Function

private extension ImageContentView {
    
    private func loadImage() {
        guard  let url = url else { return }
        
        image = nil
        ImageController.shared.fetch(from: url, success: { [weak self] (image) in
            self?.image = image
            self?.delegate?.imageLoaded(image)
        }) {  [weak self] (error) in
            self?.delegate?.failLoading(error)
        }
    }
}
