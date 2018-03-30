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

    var oldAfter: String?
    var oldBefore: String?
    var oldPage = 0
    var after: String?
    var before: String?
    var page = 0
    var count = 0
    var direction = Direction.none
    
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
        before = nil
        after = nil
    }
    
    func loadList(_ direction: Direction, success: @escaping () -> Void, error errorHandle: @escaping (String) -> Void) {
        RedditController.shared.top(direction, success: { result in
            self.list = result.children ?? []
            self.oldAfter = self.after
            self.oldBefore = self.before
            self.oldPage = self.page
            self.after = result.after
            self.before = result.before
 
            self.direction = direction
            switch direction {
            case .none:
                self.page = 0
                self.count = 0

            case .after:
                self.count = (self.page + 1) * 25
                self.page += 1

            case .before:
                self.count = self.page * 25 + 1
                self.page -= 1
            }
            
            success()
        }, error: { error in
            errorHandle(error)
        })
    }
}

// MARK: - API

fileprivate extension RedditController {
    
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
