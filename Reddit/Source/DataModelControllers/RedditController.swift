//
//  RedditController.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

final class RedditController {
    
    // MARK: - Singleton
    
    static let shared = RedditController()

    private let service = RedditService()

    private init() {
        
    }
}

// MARK: - API

extension RedditController {
    func top(success : @escaping  (Top)->Void , error errorCallback : @escaping  (String) -> Void) {
        service.top(responseQueue: .main, success: success, error: errorCallback)
        
    }
}
