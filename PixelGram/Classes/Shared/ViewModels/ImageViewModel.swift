//
//  ImageViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class ImageViewModel {
    
    private var image: Image
    
    init(with image: Image) {
        self.image = image
    }
    
    var imageURL: URL? {
        return URL(string: image.url)
    }
    
    var usernameText: String {
        return image.owner.username
    }
    
    var ownerAvatarURL: URL? {
        return URL(string: image.owner.avatarURL)
    }
    
    var likesText: String {
        return "\(image.usersLiked?.count ?? 0) likes"
    }
    
}
