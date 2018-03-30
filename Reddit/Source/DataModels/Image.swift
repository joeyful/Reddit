//
//  Image.swift
//  Reddit
//
//  Created by Joey Wei on 3/30/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

struct Preview : Codable {
    let images : [Image]?
    
    var imageURL : URL? {
        return images?.first?.url
    }
}

struct Image : Codable {
    let url : URL?
    let width : Int?
    let height: Int?
    
    enum CodingKeys: String, CodingKey {
        case source
    }
    
    enum ImageKeys: String, CodingKey {
        case url
        case width
        case height
    }
    
    init(from decoder : Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let source = try container.nestedContainer(keyedBy: ImageKeys.self, forKey: .source)
        url = try source.decodeIfPresent(URL.self, forKey: .url)
        width = try source.decodeIfPresent(Int.self, forKey: .width)
        height = try source.decodeIfPresent(Int.self, forKey: .height)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var source = container.nestedContainer(keyedBy: ImageKeys.self, forKey: .source)
        try source.encodeIfPresent(url, forKey: .url)
        try source.encodeIfPresent(width, forKey: .width)
        try source.encodeIfPresent(height, forKey: .height)
    }
}
