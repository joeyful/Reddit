//
//  RedditAPI.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

class RedditAPI : API  {
    
    let baseURL = URL(string: "https://www.reddit.com")!
    
    fileprivate var session : URLSession {
        
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 15 // Time out after 15 seconds
        
        return URLSession(configuration: configuration)
    }
    
    func send<T : Decodable>(_ request: APIRequest, success : @escaping (T, URL) -> Void, error errorCallback: @escaping (String) -> Void) {
        
        send(request, success: { (data, url) in
            self.decode(data: data, url: url, success: success, error: errorCallback)
        }, error: errorCallback)
    }
    
    fileprivate func send(_ request: APIRequest, success: @escaping (Data, URL) -> Void, error errorBlock :@escaping (String) -> Void) {
        
        guard let urlRequest = request.urlRequest(base: baseURL), let fullURL = urlRequest.url else {
            DispatchQueue.main.async {
                errorBlock("NetworkError.invalidURL")
            }
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                errorBlock(error.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                errorBlock("NetworkError.httpError: \(httpResponse.statusCode)")
            }
            else if let data = data {
                success(data, fullURL)
            }
            else {
                errorBlock("NetworkError.noData")
            }
        }
        
        task.resume()
    }
    
    fileprivate func decode<T : Decodable>(data: Data, url : URL, success : @escaping (T, URL) -> Void, error errorCallback: @escaping (String) -> Void) {
        do {
            
            let result = try JSONDecoder() .decode(T.self, from: data)
            
            success(result, url)
        }
        catch (_) {
            errorCallback("ParserError.invalidFormat")
        }
    }
}
