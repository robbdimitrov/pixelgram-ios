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
    
    private var dateFormatter = DateFormatter()
    
    init(with image: Image) {
        self.image = image
        
        configureDateFormatter()
    }
    
    // Getters
    
    var imageURL: URL? {
        return URL(string: image.url)
    }
    
    var usernameText: String {
        return image.owner.username
    }
    
    var ownerAvatarURL: URL? {
        if let avatarURL = image.owner.avatarURL {
            return URL(string: avatarURL)
        }
        return nil
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
    
    var dateCreatedText: String {
        return dateFormatter.string(from: image.dateCreated)
    }
    
    // Configure date formatter
    
    func configureDateFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
}
