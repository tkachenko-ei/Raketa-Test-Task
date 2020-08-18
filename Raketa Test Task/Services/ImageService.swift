//
//  ImageService.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    private let imageCache = NSCache<NSString, UIImage>()

    // MARK: - Singleton
    
    static let shared = ImageService()
    private init() {}
    
    // MARK: - Methods
    
    func downloadImage(url: URL?, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let _ = error {
                    completion(nil)
                } else if let data = data, let image = UIImage(data: data) {
                    ImageService.shared.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image)
                } else {
                    completion(nil)
                }
            }

            task.resume()
        }
    }

}
