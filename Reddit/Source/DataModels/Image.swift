//
//  Image.swift
//  Reddit
//
//  Created by Joey Wei on 3/30/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

struct Image : Codable {
    let url : URL?
    let width : Int?
    let height: Int?
    
    enum PreviewKeys: String, CodingKey {
        case images, enabled
    }
    
    enum ImagesKeys: String, CodingKey {
        case source
    }
    
    enum SourceKeys: String, CodingKey {
        case url
        case width
        case height
    }
    
    init(from decoder: Decoder) throws {
        let previewContainer = try decoder.container(keyedBy: PreviewKeys.self)
        
        var imagesUnkeyedContainer = try previewContainer.nestedUnkeyedContainer(forKey: .images)
        let imageContainer = try imagesUnkeyedContainer.nestedContainer(keyedBy: ImagesKeys.self)
        
        let sourceContainer = try imageContainer.nestedContainer(keyedBy: SourceKeys.self, forKey: .source)
        url = try sourceContainer.decodeIfPresent(URL.self, forKey: .url)
        width = try sourceContainer.decodeIfPresent(Int.self, forKey: .width)
        height = try sourceContainer.decodeIfPresent(Int.self, forKey: .height)
    }
}
