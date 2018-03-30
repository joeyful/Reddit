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
    var parameters    : [(String,String)] = []
    var headers       : [String:String]   = [:]
    

    init(_ verb : Verb, path: String) {
        self.verb = verb
        self.relativePath = path
    }
    
    func urlRequest(base baseURL : URL) -> URLRequest? {
        
        let queryParmeters = encode(parameters: parameters).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let pathWithParameters = queryParmeters.isEmpty ? relativePath : relativePath + "?" + queryParmeters
        
        guard let fullURL = URL(string: pathWithParameters, relativeTo: baseURL) else { return nil }
//        print("\(fullURL.absoluteString)")
        var urlRequest = URLRequest(url: fullURL)
        urlRequest.httpMethod = verb.rawValue
        
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    fileprivate func encode(parameters: [(String,String)]) -> String {
        
        let parameterStrings : [String] = parameters.flatMap {
            
            guard let key = $0.0.addingQueryParameterPercentEncoding, let value = $0.1.addingQueryParameterPercentEncoding else { return nil }
            
            return key + "=" + value
        }
        
        return parameterStrings.joined(separator: "&")
    }
}

