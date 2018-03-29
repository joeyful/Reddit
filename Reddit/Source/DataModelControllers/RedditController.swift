//
//  RedditController.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

final class RedditController {
    
    var topList: [Child]?
    
    var listCount: Int {
        return topList?.count ?? 0
    }
    
    // MARK: - Singleton
    
    static let shared = RedditController()

    private let service = RedditService()

    private init() {
        
    }
    
    func loadTopList(success: @escaping () -> Void, error errorHandle: @escaping (String) -> Void) {
        RedditController.shared.top(success: { result in
            self.topList = result.children
            success()
        }, error: { error in
            errorHandle(error)
        })
    }
}

// MARK: - API

extension RedditController {
    func top(success : @escaping  (Top)->Void , error errorCallback : @escaping  (String) -> Void) {
        service.top(responseQueue: .main, success: success, error: errorCallback)
        
    }
}
