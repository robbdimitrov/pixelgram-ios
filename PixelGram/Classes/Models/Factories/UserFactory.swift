//
//  UserFactory.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/16/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class UserFactory {

    class func createUser(_ dictionary: [String: AnyObject]) -> User {
        let user = User(id: (dictionary["_id"] as? String) ?? "",
                        name: (dictionary["name"] as? String) ?? "",
                        username: (dictionary["username"] as? String) ?? "",
                        email: (dictionary["email"] as? String) ?? "",
                        avatarURL: (dictionary["avatar"] as? String) ?? "",
                        bio: (dictionary["bio"] as? String) ?? "",
                        images: (dictionary["images"] as? [String])?.count ?? 0,
                        likedImages: (dictionary["bio"] as? [String])?.count ?? 0)
        return user
    }

}
