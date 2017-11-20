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
    
    var image: Image
    var user: User?
    var likes: Variable<Int>
    
    static let dateFormatter = DateFormatter()
    
    init(with image: Image) {
        likes = Variable(image.likes)
        self.image = image
        
        user = UserLoader.sharedInstance.user(withId: image.owner)
        
        configureDateFormatter()
    }
    
    // Getters
    
    func likeImage(with user: User) {
        
    }
    
    var isOwnedByCurrentUser: Bool {
        if let currentUserId = Session.sharedInstance.currentUser?.id {
            return image.owner == currentUserId
        }
        return false
    }
    
    var imageURL: URL? {
        if image.filename.count > 0 {
            return URL(string: APIClient.sharedInstance.urlForImage(image.filename))
        }
        return nil
    }
    
    var usernameText: String {
        return user?.username ?? "Loading.."
    }
    
    var ownerAvatarURL: URL? {
        if let avatarURL = user?.avatarURL, avatarURL.count > 0 {
            return URL(string: APIClient.sharedInstance.urlForImage(avatarURL))
        }
        return nil
    }
    
    var likesText: String {
        return "\(image.likes) likes"
    }
    
    var descriptionText: NSAttributedString? {
        let usernameFont = UIFont.boldSystemFont(ofSize: 15.0)
        
        let attributedString = NSMutableAttributedString(string: "\(user?.username ?? "Loading...") \(image.description)")
        
        attributedString.setAttributes([.font : usernameFont], range: (attributedString.string as NSString).range(of: user?.username ?? "Loading..."))
        
        return attributedString
    }
    
    var dateCreatedText: String {
        return ImageViewModel.dateFormatter.string(from: image.dateCreated)
    }
    
    // Configure date formatter
    
    func configureDateFormatter() {
        ImageViewModel.dateFormatter.dateStyle = .medium
        ImageViewModel.dateFormatter.timeStyle = .short
        ImageViewModel.dateFormatter.doesRelativeDateFormatting = true
    }
    
}
