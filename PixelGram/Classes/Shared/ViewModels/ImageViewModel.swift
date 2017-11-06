//
//  ImageViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift

class ImageViewModel {
    
    private var image: Image
    var usersLiked: Variable<[User]>
    
    private var dateFormatter = DateFormatter()
    
    init(with image: Image) {
        usersLiked = Variable(image.usersLiked ?? [])
        self.image = image
        
        configureDateFormatter()
    }
    
    // Getters
    
    func likeImage(with user: User) {
        let alreadyLiked = user.likedImages?.contains(where: { [weak self] (image) -> Bool in
            image === self?.image
        }) ?? false
        
        if alreadyLiked {
            guard let index = user.likedImages?.index(where: { [weak self] image -> Bool in
                image === self?.image
            }) else {
                return
            }
            
            guard let userIndex = image.usersLiked?.index(where: { user -> Bool in
                user === Session.sharedInstance.currentUser
            }) else {
                return
            }
            
            user.likedImages?.remove(at: index)
            image.usersLiked?.remove(at: userIndex)
            usersLiked.value = image.usersLiked ?? []
        } else {
            user.likedImages?.append(image)
            image.usersLiked?.append(user)
            usersLiked.value = image.usersLiked ?? []
        }
    }
    
    var isOwnedByCurrentUser: Bool {
        return image.owner === Session.sharedInstance.currentUser
    }
    
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
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
    }
    
}
