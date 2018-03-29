//
//  APIRequest.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

struct APIRequest {
    
    enum Verb : String {
        case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
    }
    
    let verb          : Verb
    var relativePath  : String
    
    init(_ verb : Verb, path: String) {
        self.verb = verb
        self.relativePath = path
    }
    
    func urlRequest(base baseURL : URL) -> URLRequest? {
        
        guard let fullURL = URL(string: relativePath, relativeTo: baseURL) else { return nil }
        
        var urlRequest = URLRequest(url: fullURL)
        urlRequest.httpMethod = verb.rawValue
        
        return urlRequest
    }
}
