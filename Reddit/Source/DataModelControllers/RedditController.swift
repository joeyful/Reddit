//
//  RedditController.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

final class RedditController {
    let pageSize = 25

    private(set) var previousAfter: String?
    private(set) var previousBefore: String?
    private(set) var previousPage = 0
    private(set) var after: String?
    private(set) var before: String?
    private(set) var page = 0
    private(set) var direction = Direction.none
    private(set) var list = [Child]()
    
    var listCount: Int {
        return list.count
    }
    
    
    // MARK: - Singleton
    
    static let shared = RedditController()
    private let service = RedditService()
    private init() {
        
    }
}


// MARK: - Public API

extension RedditController {
    
    func reset() {
        list =  []
        before = nil
        after = nil
    }
    
    func restore(before: String?, after: String?, page: Int, direction: Direction) {
        self.page = page
        self.before = before
        self.after = after
        self.direction = direction
    }
    
    func loadList(_ direction: Direction, success: @escaping () -> Void, error errorHandle: @escaping (String) -> Void) {
        RedditController.shared.top(direction, success: { result in
            self.list = result.children ?? []
            self.previousAfter = self.after
            self.previousBefore = self.before
            self.previousPage = self.page
            self.after = result.after
            self.before = result.before
            
            self.direction = direction
            switch direction {
            case .none:
                self.page = 0
                
            case .after:
                self.page += 1
                
            case .before:
                self.page -= 1
            }
            
            success()
        }, error: { error in
            errorHandle(error)
        })
    }
}


// MARK: - Private Function

private extension RedditController {
    
    func top(_ direction: Direction, success : @escaping  (Top)->Void , error errorCallback : @escaping  (String) -> Void) {
        switch direction {
        case .none:
            service.top(after: nil, before: nil, count: 0, responseQueue: .main, success: success, error: errorCallback)

        case .after:
            service.top(after: after, before: nil, count: (page + 1) * 25, responseQueue: .main, success: success, error: errorCallback)

        case .before:
            service.top(after: nil, before: before, count: page * 25 + 1, responseQueue: .main, success: success, error: errorCallback)
        }
    }
}
