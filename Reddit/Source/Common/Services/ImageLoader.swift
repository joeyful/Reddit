//
//  ImageLoader.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    
    let session = URLSession(configuration: .default)
    
    func load(from url : URL, success : @escaping (UIImage) -> Void, error errorHandler : @escaping (String) -> Void) {
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                errorHandler(error.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                errorHandler("NetworkError.httpError: \(httpResponse.statusCode)")
            }
            else if let data = data {
                
                if let image = UIImage(data: data) {
                    success(image)
                }
                else {
                    errorHandler("ParseError.invalidFormat")
                }
            }
            else {
                errorHandler("NetworkError.noData")
            }
        }
        
        task.resume()
    }
}

