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
        if user.avatarURL.count > 0 {
            return URL(string: APIClient.sharedInstance.urlForImage(user.avatarURL))
        }
        return nil
    }
    
    var nameText: String {
        return user.name
    }
    
    var usernameText: String {
        return user.username
    }
    
    var emailText: String {
        return user.email
    }
    
    var imagesNumberText: String {
        return "\(user.images)"
    }
    
    var likesNumberText: String {
        return "\(user.likes)"
    }
    
    var bioText: String? {
        return user.bio;
    }
    
    var isCurrentUser: Bool {
        return user.id == (Session.sharedInstance.currentUser?.id ?? "")
    }
    
}
