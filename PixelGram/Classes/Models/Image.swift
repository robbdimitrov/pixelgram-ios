//
//  Image.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class Image {

    var owner: User
    var url: String
    var dateCreated: Date
    var description: String?
    var usersLiked: [User]?
    
    init(owner: User, url: String, dateCreated: Date,
         description: String, usersLiked: [User]?) {
        self.owner = owner
        self.url = url
        self.dateCreated = dateCreated
        self.description = description
        self.usersLiked = usersLiked
    }
    
}
