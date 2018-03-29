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
    let children : [Child]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum TopKeys: String, CodingKey {
        case after
        case children
    }
    
    init(from decoder : Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: TopKeys.self, forKey: .data)
        after = try data.decodeIfPresent(String.self, forKey: .after)
        children = try data.decodeIfPresent([Child].self, forKey: .children)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var data = container.nestedContainer(keyedBy: TopKeys.self, forKey: .data)
        try data.encodeIfPresent(after, forKey: .after)
        try data.encodeIfPresent(children, forKey: .children)
    }
}

