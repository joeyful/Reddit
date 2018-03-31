//
//  Top.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

struct Top : Codable {
    
    let after : String?
    let before : String?
    let children : [Child]?
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    enum TopKeys: String, CodingKey {
        case after
        case before
        case children
    }
    
    init(from decoder : Decoder) throws {
        
        let container = try decoder.container(keyedBy: DataKeys.self)
        let data = try container.nestedContainer(keyedBy: TopKeys.self, forKey: .data)
        after = try data.decodeIfPresent(String.self, forKey: .after)
        before = try data.decodeIfPresent(String.self, forKey: .before)
        children = try data.decodeIfPresent([Child].self, forKey: .children)
    }
}

