//
//  PostCellViewModel.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation
import Combine

final class PostCellViewModel {
    
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var commentsCount: String = ""
    @Published var createdDate: String = ""
    @Published var preview: URL? = nil
    
    private let post: Post
    
    // MARK: - Init
    
    init(post: Post) {
        self.post = post
        
        setUpBindings()
    }
    
    // MARK: - UI
    
    private func setUpBindings() {
        title = post.title ?? ""
        author = "Author: " + post.author
        commentsCount = "\(post.commentsCount) comments"
        createdDate = RelativeDateTimeFormatter().localizedString(for: post.created, relativeTo: Date())
        preview = post.preview
    }
}
