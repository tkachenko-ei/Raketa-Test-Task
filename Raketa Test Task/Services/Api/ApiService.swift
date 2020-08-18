//
//  ApiService.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation
import Combine

class ApiService {

    // MARK: - Singleton
    
    static let shared = ApiService()
    private init() {}
    
    // MARK: - Methods
    
    func getTopPosts(pagePath: String? = nil) -> AnyPublisher<(posts: [Post], nextPage: String?), Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<(posts: [Post], nextPage: String?), Error> { promise in
            guard let urlRequest = ApiRequest.getTopPosts.getUrlRequest(pagePath != nil ? ["after": pagePath!] : [:]) else {
                promise(.failure(ApiError.urlRequest))
                return
            }
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let result = try decoder.decode(ApiResult<Post>.self, from: data)
                    guard let posts = result.children else {
                        promise(.failure(ApiError.decode))
                        return
                    }
                    promise(.success((posts: posts, nextPage: result.after)))
                } catch {
                    promise(.failure(ApiError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

