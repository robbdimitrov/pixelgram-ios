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
                        avatarURL: (dictionary["avatarURL"] as? String) ?? "",
                        bio: (dictionary["bio"] as? String) ?? "")
        return user
    }

}
