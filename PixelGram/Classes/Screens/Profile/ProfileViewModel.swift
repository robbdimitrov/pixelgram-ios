//
//  ProfileViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import RxSwift

class ProfileViewModel {

    // MARK: - Internal
    
    var user: Variable<User>
    var images: Variable<[Image]>
    
    // MARK: - Properties
    
    var userViewModel: UserViewModel
    
    var numberOfItems: Int {
        return images.value.count
    }
    
    // MARK: - Lifecycle
    
    init(with user: User) {
        self.user = Variable(user)
        images = Variable([])
        userViewModel = UserViewModel(with: self.user.value)
    }
    
    // MARK: - Getters
    
    func imageViewModel(forIndex index: Int) -> ImageViewModel {
        return ImageViewModel(with: images.value[index])
    }
    
}
