//
//  User.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

struct User {
    
    var name: String = ""
    var username: String = ""
    var email: String = ""
    var avatarURL: String = ""
    var bio: String? = ""
    var images: [Image]?
    var likedImages: [Image]?
    
}
