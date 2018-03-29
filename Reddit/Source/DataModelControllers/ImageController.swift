//
//  ImageController.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    
    static let shared = ImageController()
    
    fileprivate let loader = ImageLoader()
    fileprivate let cache = NSCache<NSString, UIImage>()
    fileprivate let connectionRetryLimit = 8
    
    private init() {
        
    }
    
    func fetch(from url : URL, success : @escaping (UIImage) -> Void, error errorHandler : @escaping (String) -> Void) {
        fetch(from: url, retryCount: 0, success: success, error: errorHandler)
    }
    
    fileprivate func fetch(from url : URL, retryCount: Int, success : @escaping (UIImage) -> Void, error errorHandler : @escaping (String) -> Void) {
        
        let urlString = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: urlString) {
            
            DispatchQueue.main.async {
                success(cachedImage)
            }
        }
        else {
            
            loader.load(from: url, success: { (image) in
                
                DispatchQueue.main.async {
                    self.cache.setObject(image, forKey: urlString)
                    success(image)
                }
            }, error: { (error) in
                
                if retryCount < self.connectionRetryLimit {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.retryTimeInterval(forRetryCount: retryCount)) {
                        self.fetch(from: url, retryCount: retryCount + 1, success: success, error: errorHandler)
                    }
                } else {
                    DispatchQueue.main.async {
                        errorHandler(error)
                    }
                }
            })
        }
    }
    
    fileprivate func retryTimeInterval(forRetryCount retryCount : Int) -> DispatchTimeInterval {
        return .milliseconds(500 * (retryCount ^ 2))
    }
    
}

