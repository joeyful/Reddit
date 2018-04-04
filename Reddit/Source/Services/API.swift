//
//  API.swift
//  Reddit
//
//  Created by Joey Wei on 3/28/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import Foundation

protocol API {
    
    var baseURL : URL { get }

    func send<T : Decodable>(_ request: APIRequest, success : @escaping (T, URL) -> Void, error errorCallback: @escaping (String) -> Void)
}

