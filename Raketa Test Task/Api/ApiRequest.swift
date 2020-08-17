//
//  ApiRequest.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation

enum ApiRequest {
    case getTopPosts
}

extension ApiRequest {
    var baseUrl: String {
        return "https://www.reddit.com"
    }
    
    var path: String {
        switch self {
        case .getTopPosts:
            return "/top.json"
        }
    }
}
