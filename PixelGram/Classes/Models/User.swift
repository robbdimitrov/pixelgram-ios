//
//  User.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

class User {
    
    var name: String
    var username: String
    var email: String
    var avatarURL: String?
    var bio: String?
    var images: [Image]?
    var likedImages: [Image]?
    
    init(name: String, username: String, email: String, avatarURL: String,
         bio: String?, images: [Image]?, likedImages: [Image]?) {
        self.name = name
        self.username = username
        self.email = email
        self.avatarURL = avatarURL
        self.bio = bio
        self.images = images
        self.likedImages = likedImages
    }
    
}
