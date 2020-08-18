//
//  ApiResult.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation

struct ApiResult<T: Codable>: Decodable {
    
    var children: [T]?
    var after: String?
    var before: String?
    
    // MARK: - Codable
    
    enum DataCodingKeys: String, CodingKey {
        case data
    }
    
    enum CodingKeys: String, CodingKey {
        case children
        case after
        case before
    }

    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: DataCodingKeys.self)
        
        let container = try dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        children = try? container.decode([T].self, forKey: .children)
        after = try? container.decode(String.self, forKey: .after)
        before = try? container.decode(String.self, forKey: .before)
    }
}
