//
//  Image.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

struct Image {

    var owner: User
    var url: String
    var dateCreated: Date
    var description: String?
    var usersLiked: [User]?
    
}
