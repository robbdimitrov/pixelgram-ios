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
    var likes: Variable<Int>
    
    private var dateFormatter = DateFormatter()
    
    init(with image: Image) {
        likes = Variable(image.likes)
        self.image = image
        
        configureDateFormatter()
    }
    
    // Getters
    
    func likeImage(with user: User) {
//        let alreadyLiked = user.likedImages?.contains(where: { [weak self] (image) -> Bool in
//            image === self?.image
//        }) ?? false
//        
//        if alreadyLiked {
//            guard let index = user.likedImages?.index(where: { [weak self] image -> Bool in
//                image === self?.image
//            }) else {
//                return
//            }
//
//            guard let userIndex = image.usersLiked?.index(where: { user -> Bool in
//                user === Session.sharedInstance.currentUser
//            }) else {
//                return
//            }
//
//            user.likedImages?.remove(at: index)
//            image.usersLiked?.remove(at: userIndex)
//            usersLiked.value = image.usersLiked ?? []
//        } else {
//            user.likedImages?.append(image)
//            image.usersLiked?.append(user)
//            usersLiked.value = image.usersLiked ?? []
//        }
    }
    
    var isOwnedByCurrentUser: Bool {
        if let currentUserId = Session.sharedInstance.currentUser?.id {
            return image.owner == currentUserId
        }
        return false
    }
    
    var imageURL: URL? {
        return URL(string: APIClient.sharedInstance.urlForImage(image.filename))
    }
    
    var usernameText: String {
        return "Namename"//image.owner.username
    }
    
    var ownerAvatarURL: URL? {
        return nil//URL(string: image.owner.avatarURL)
    }
    
    var likesText: String {
        return "\(image.likes) likes"
    }
    
    var descriptionText: NSAttributedString? {
        let usernameFont = UIFont.boldSystemFont(ofSize: 15.0)
        
        let attributedString = NSMutableAttributedString(string: "\("image.owner.username") \(image.description)")
        
        attributedString.setAttributes([.font : usernameFont], range: (attributedString.string as NSString).range(of: "image.owner.username"))
        
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
