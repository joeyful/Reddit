//
//  RedditService.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation


class RedditService {

    fileprivate let api : API
    
    init(api : API) {
        self.api = api
    }
    
    convenience init() {
        self.init(api: RedditAPI())
    }
    
    func top(responseQueue: DispatchQueue, success: @escaping (Top) -> Void, error errorCallback: @escaping (String) -> Void) {
        
        let request = APIRequest(.post, path: "top.json")
        
        api.send(request, success: { (result, url) in
            responseQueue.async {
                success(result)
            }
        }, error: { error in
            
            responseQueue.async {
                errorCallback(error)
            }
        })
    }
}
