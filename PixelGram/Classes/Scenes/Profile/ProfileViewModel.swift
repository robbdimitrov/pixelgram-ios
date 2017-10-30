//
//  ProfileViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import RxSwift

class ProfileViewModel {

    var user: Variable<User>
    var images: Variable<[Image]>
    
    var userObservable: Observable<User> {
        return user.asObservable()
    }
    var imagesObservable: Observable<[Image]> {
        return images.asObservable()
    }
    
    var userViewModel: UserViewModel {
        return UserViewModel(with: user.value)
    }
    
    init(with user: User) {
        self.user = Variable(user)
        images = Variable(user.images ?? [])
        
        print("ProfileViewModel created: number of images: \(images.value.count)")
    }
    
}
