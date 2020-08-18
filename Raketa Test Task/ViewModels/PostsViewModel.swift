//
//  PostsViewModel.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation
import Combine

class PostsViewModel {
    
    @Published private(set) var postsViewModels: [PostCellViewModel] = []
    @Published private(set) var state: ListViewModelState = .loading
    
    private var nextPagePath: String?
    
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        getPosts()
    }
    
    // MARK: - Methods
    
    func nextPage() {
        switch state {
        case .loading:
            return
        default:
            getPosts(pagePath: nextPagePath)
        }
    }
    
    func refresh() {
        nextPagePath = nil
        getPosts()
    }
    
    // MARK: - Get posts
    
    private func getPosts(pagePath: String? = nil) {
        state = .loading
        
        let getPostsTermCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error): self?.state = .error(error)
            case .finished: self?.state = .finishedLoading
            }
        }
        
        let getPostsTermValueHandler: ((posts: [Post], nextPage: String?)) -> Void = { [weak self] result in
            if self?.nextPagePath == nil {
                self?.postsViewModels = result.posts.map { PostCellViewModel(post: $0) }
            } else {
                self?.postsViewModels += result.posts.map { PostCellViewModel(post: $0) }
            }
            self?.nextPagePath = result.nextPage
        }
        
        ApiService.shared
            .getTopPosts(pagePath: pagePath)
            .sink(receiveCompletion: getPostsTermCompletionHandler, receiveValue: getPostsTermValueHandler)
            .store(in: &bindings)
    }

}
