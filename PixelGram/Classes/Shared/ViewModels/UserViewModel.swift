//
//  UserViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class UserViewModel {

    private var user: User
    
    init(with user: User) {
        self.user = user
    }
    
    var avatarURL: URL? {
        if let avatarURL = user.avatarURL {
            return URL(string: avatarURL)
        }
        return nil
    }
    
    var nameText: String {
        return user.name
    }
    
    var usernameText: String {
        return user.username
    }
    
    var imagesNumberText: String {
        return "\(user.images?.count ?? 0)"
    }
    
    var likesNumberText: String {
        return "\(user.likedImages?.count ?? 0)"
    }
    
    var bioText: String? {
        return user.bio;
    }
    
    var isCurrentUser: Bool {
        return user.id == (Session.sharedInstance.currentUser?.id ?? "")
    }
    
}
