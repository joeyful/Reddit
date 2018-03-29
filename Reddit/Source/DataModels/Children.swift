//
//  Children.swift
//  Reddit
//
//  Created by Joey Wei on 3/29/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

struct Child : Codable {
    
    let title : String?
    let author : String?
    let thumbnail: URL?
    let createdUTC: Date?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum ChildKeys: String, CodingKey {
        case title
        case author
        case thumbnail
        case createdUTC = "created_utc"
    }
    
    init(from decoder : Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: ChildKeys.self, forKey: .data)
        title = try data.decodeIfPresent(String.self, forKey: .title)
        author = try data.decodeIfPresent(String.self, forKey: .author)
        thumbnail = try data.decodeIfPresent(URL.self, forKey: .thumbnail)
        
        if let timestamp = try data.decodeIfPresent(Double.self, forKey: .createdUTC) {
            createdUTC = Date(timeIntervalSince1970: timestamp)
        }
        else {
            createdUTC = Date.distantFuture
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var data = container.nestedContainer(keyedBy: ChildKeys.self, forKey: .data)
        try data.encodeIfPresent(title, forKey: .title)
        try data.encodeIfPresent(author, forKey: .author)
        try data.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try data.encodeIfPresent(createdUTC?.timeIntervalSince1970, forKey: .createdUTC)
    }
}
