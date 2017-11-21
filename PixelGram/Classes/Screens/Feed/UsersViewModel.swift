//
//  UsersViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/21/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class UsersViewModel {

    // MARK: - Properties
    
    var imageId: String?
    var users = [User]()
    
    // MARK: - Lifecycle
    
    init(with imageId: String) {
        self.imageId = imageId
    }
    
    // MARK: - Getters
    
    func userViewModel(forIndex index: Int) -> UserViewModel {
        return UserViewModel(with: users[index])
    }
    
    var numberOfItems: Int {
        return users.count
    }
    
}
