//
//  RedditController.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

final class RedditController {
    
    private var after: String?

    private(set) var list = [Child]()
    
    var listCount: Int {
        return list.count
    }
    
    
    // MARK: - Singleton
    
    static let shared = RedditController()

    private let service = RedditService()

    private init() {
        
    }
    
    func reset() {
        list =  []
        after = nil
    }
    
    func loadList(success: @escaping () -> Void, error errorHandle: @escaping (String) -> Void) {
        RedditController.shared.top(success: { result in
            self.list += result.children ?? []
            self.after = result.after
            success()
        }, error: { error in
            errorHandle(error)
        })
    }
}

// MARK: - API

fileprivate extension RedditController {
    
    func top(success : @escaping  (Top)->Void , error errorCallback : @escaping  (String) -> Void) {
        service.top(after: after, count: "\(listCount)", responseQueue: .main, success: success, error: errorCallback)
    }
}
