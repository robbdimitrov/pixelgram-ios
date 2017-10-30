//
//  ImageViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

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
    
    var descriptionText: NSAttributedString? {
        guard let description = image.description else {
            print("Image description is empty")
            return nil
        }
        
        let usernameFont = UIFont.boldSystemFont(ofSize: 15.0)
        
        let attributedString = NSMutableAttributedString(string: "\(image.owner.username) \(description)")
        
        attributedString.setAttributes([.font : usernameFont], range: (attributedString.string as NSString).range(of: image.owner.username))
        
        return attributedString
    }
    
}
