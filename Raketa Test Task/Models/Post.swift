//
//  Post.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation

struct Post: Codable {
    
    var id: String
    var title: String?
    var preview: URL?
    var author: String
    var commentsCount: Int
    var created: Date
    
    // MARK: - Codable
    
    enum DataCodingKeys: String, CodingKey {
        case data
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case preview = "thumbnail"
        case author
        case commentsCount = "num_comments"
        case created = "created_utc"
    }
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: DataCodingKeys.self)
        
        let container = try dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        preview = try container.decode(URL.self, forKey: .preview)
        author = try container.decode(String.self, forKey: .author)
        commentsCount = try container.decode(Int.self, forKey: .commentsCount)
        created = try container.decode(Date.self, forKey: .created)
    }
}
