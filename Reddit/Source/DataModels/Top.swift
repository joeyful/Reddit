//
//  Top.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

struct Top : Codable {
    let kind : String?
    let data : TopGroup?
}

struct TopGroup : Codable {
    let after : String?
    let children : [Child]?
}

struct Child : Codable {
    let data : ChildData?
}

struct ChildData : Codable {
    
    let title : String?
    let author : String?
    let thumbnail: URL?
    let createdUTC: Date?
    
    enum CodingKeys : String, CodingKey {
        case title
        case author
        case thumbnail
        case createdUTC = "created_utc"
    }
    
    init(from decoder : Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        
        if let timestamp = try container.decodeIfPresent(Double.self, forKey: .createdUTC) {
            createdUTC = Date(timeIntervalSince1970: timestamp)
        }
        else {
            createdUTC = Date.distantFuture
        }
        
        if let urlString = try container.decodeIfPresent(String.self, forKey: .thumbnail) {
            thumbnail = URL(string: urlString)
        }
        else {
            thumbnail = nil
        }
    }
}

