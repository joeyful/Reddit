//
//  RedditService.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation


class RedditService {

    private let api : API
    private let connectionRetryLimit = 2

    init(api : API) {
        self.api = api
    }
    
    convenience init() {
        self.init(api: RedditAPI())
    }
    
    func top(after: String?, before: String?, count: Int, retryCount: Int = 3, responseQueue: DispatchQueue, success: @escaping (Top) -> Void, error errorCallback: @escaping (String) -> Void) {
        
        var request = APIRequest(.get, path: "top.json")
        
        if let after = after {
            request.parameters = request.parameters + [("after", after), ("count", "\(count)")]
        }
        else if let before = before {
            request.parameters = request.parameters + [("before", before), ("count", "\(count)")]
        }
        
        api.send(request, success: { (result, url) in
            responseQueue.async {
                success(result)
            }
        }, error: { error in
            
            if retryCount < self.connectionRetryLimit {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.retryTimeInterval(forRetryCount: retryCount)) {
                    self.top(after: after, before: before, count: retryCount + 1, responseQueue: responseQueue, success: success, error: errorCallback)
                }
            } else {
                responseQueue.async {
                    errorCallback(error)
                }
            }
        })
    }
    
    private func retryTimeInterval(forRetryCount retryCount : Int) -> DispatchTimeInterval {
        return .milliseconds(500 * (retryCount ^ 2))
    }
}
