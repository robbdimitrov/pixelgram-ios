//
//  Image.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class Image {

    var id: String
    var owner: String
    var filename: String
    var dateCreated: Date
    var description: String
    var likes: Int
    var isLiked: Bool
    
    init(id: String, owner: String, filename: String, dateCreated: Date,
         description: String, likes: Int, isLiked: Bool) {
        self.id = id
        self.owner = owner
        self.filename = filename
        self.dateCreated = dateCreated
        self.description = description
        self.likes = likes
        self.isLiked = isLiked
    }
    
}
