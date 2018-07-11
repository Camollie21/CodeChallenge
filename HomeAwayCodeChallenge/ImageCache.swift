//
//  ImageCache.swift
//  HomeAwayCodeChallenge
//
//  Created by Cameron Ollivierre on 6/29/18.
//  Copyright © 2018 Cameron Ollivierre. All rights reserved.
//

import UIKit

class ImageCache: ImageCaching {
    var cacheDictionary = Dictionary<String, UIImage>()
        
    func saveImageToCache(image: UIImage?, url: URL) {
        if let image = image {
            cacheDictionary[url.absoluteString] = image
        }
    }
        
    func imageFromCacheWithUrl(url: URL)-> UIImage? {
        return cacheDictionary[url.absoluteString]
    }
}
