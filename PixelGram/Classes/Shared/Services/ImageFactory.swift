//
//  ImageFactory.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/16/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class ImageFactory {

    static let dateFormatter = DateFormatter()
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    class func createImage(_ dictionary: [String: AnyObject]) -> Image {
        dateFormatter.dateFormat = dateFormat
        
        let image = Image(id: (dictionary["_id"] as? String) ?? "",
                          owner: (dictionary["ownerId"] as? String) ?? "",
                          filename: (dictionary["filename"] as? String) ?? "",
                          dateCreated: dateFormatter.date(from: (dictionary["dateCreated"] as? String) ?? "") ?? Date(),
                          description: (dictionary["description"] as? String) ?? "",
                          likes: (dictionary["likes"] as? Int) ?? 0,
                          isLiked: (dictionary["isLiked"] as? Bool) ?? false)
        
        return image
    }
    
}
