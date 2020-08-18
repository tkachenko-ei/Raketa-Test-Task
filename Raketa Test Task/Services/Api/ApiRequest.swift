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
    
    private var baseUrl: String {
        return "https://www.reddit.com"
    }
    
    private var path: String {
        switch self {
        case .getTopPosts:
            return "/top.json"
        }
    }
    
    func getUrlRequest(_ parameters: [String: String] = [:]) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseUrl + path) else { return nil }
        
        var items = [URLQueryItem]()
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: value))
        }
        items = items.filter{!$0.name.isEmpty}

        if !items.isEmpty {
            urlComponents.queryItems = items
        }
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}
