//
//  ApiService.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation

class ApiService {

    // MARK: - Singleton
    
    static let shared = ApiService()
    private init() {}
    
    // MARK: - Methods
    
    func getTopPosts(completion: @escaping (Error?, [Post]?) -> ()) {
        send(.getTopPosts) { (error, data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let result = try decoder.decode(ApiResult<Post>.self, from: data)
                completion(nil, result.children)
            } catch {
                completion(error, nil)
            }
        }
    }
    
    // MARK: - Send request

    private func send(_ request: ApiRequest, completion: @escaping (Error?, Data?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: request.baseUrl + request.path) else {
                completion(NSError(domain: request.baseUrl, code: 404, userInfo: nil), nil)
                return
            }
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                completion(error, data)
            }
            task.resume()
        }
    }
    
}

