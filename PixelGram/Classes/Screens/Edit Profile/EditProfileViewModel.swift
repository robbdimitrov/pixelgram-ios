//
//  EditProfileViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class EditProfileViewModel {

    private let currentUser = Session.sharedInstance.currentUser
    
    var nameText: String? {
        return currentUser?.name
    }
    
    var usernameText: String? {
        return currentUser?.username
    }
    
    var emailText: String? {
        return currentUser?.email
    }
    
    var bioText: String? {
        return currentUser?.bio
    }
    
    var avatarURL: URL? {
        if let avatarURL = currentUser?.avatarURL {
            return URL(string: avatarURL)
        }
        return nil
    }
    
    func saveUser() {
        
    }

}
