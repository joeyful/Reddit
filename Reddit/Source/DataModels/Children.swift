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
    let numComments: Int?
    let image : Image?
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    enum ChildKeys: String, CodingKey {
        case title
        case author
        case thumbnail
        case preview
        case createdUTC = "created_utc"
        case numComments = "num_comments"
    }
    
    init(from decoder : Decoder) throws {
        
        let container = try decoder.container(keyedBy: DataKeys.self)
        let data = try container.nestedContainer(keyedBy: ChildKeys.self, forKey: .data)
        title = try data.decodeIfPresent(String.self, forKey: .title)
        author = try data.decodeIfPresent(String.self, forKey: .author)
        thumbnail = try data.decodeIfPresent(URL.self, forKey: .thumbnail)
        numComments = try data.decodeIfPresent(Int.self, forKey: .numComments)
        image = try data.decodeIfPresent(Image.self, forKey: .preview)
        
        if let timestamp = try data.decodeIfPresent(Double.self, forKey: .createdUTC) {
            createdUTC = Date(timeIntervalSince1970: timestamp)
        }
        else {
            createdUTC = Date.distantFuture
        }
    }
}
