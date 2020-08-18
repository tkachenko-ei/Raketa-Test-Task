//
//  ApiError.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case url(URLError)
    case urlRequest
    case decode
}
