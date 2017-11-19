//
//  User.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    var id: String
    var name: String
    var username: String
    var email: String
    var avatarURL: String
    var bio: String
    var images: Int
    var likes: Int
    
    init(id: String, name: String, username: String, email: String, avatarURL: String,
         bio: String, images: Int, likes: Int) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.avatarURL = avatarURL
        self.bio = bio
        self.images = images
        self.likes = likes
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(avatarURL, forKey: "avatarURL")
        aCoder.encode(bio, forKey: "bio")
        aCoder.encode(images, forKey: "images")
        aCoder.encode(likes, forKey: "likes")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        avatarURL = aDecoder.decodeObject(forKey: "avatarURL") as? String ?? ""
        bio = aDecoder.decodeObject(forKey: "bio") as? String ?? ""
        images = aDecoder.decodeObject(forKey: "images") as? Int ?? 0
        likes = aDecoder.decodeObject(forKey: "likes") as? Int ?? 0
    }
    
}
