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
        
        user = UserLoader.shared.user(withId: image.owner)
        
        configureDateFormatter()
    }
    
    // Getters
    
    var isLikedByCurrentUser: Bool {
        return image.isLiked
    }
    
    var isOwnedByCurrentUser: Bool {
        if let currentUserId = Session.shared.currentUser?.id {
            return image.owner == currentUserId
        }
        return false
    }
    
    var imageURL: URL? {
        if image.filename.count > 0 {
            return URL(string: APIClient.shared.urlForImage(image.filename))
        }
        return nil
    }
    
    var usernameText: String {
        return user?.username ?? "Loading.."
    }
    
    var ownerAvatarURL: URL? {
        if let avatarURL = user?.avatarURL, avatarURL.count > 0 {
            return URL(string: APIClient.shared.urlForImage(avatarURL))
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
    
    // MARK: - Actions
    
    func likeImage(with user: User) {
        let imageId = image.id
        
        let completion: () -> Void = { [weak self] in
            self?.image.isLiked = !(self?.image.isLiked ?? false)
        }
        
        let failure: (String) -> Void = { error in
            print("Liking image failed \(error)")
        }
        
        if isLikedByCurrentUser {
            if let userId = Session.shared.currentUser?.id {
                APIClient.shared.dislikeImage(withUserId: userId, imageId: imageId, completion: completion, failure: failure)
            }
        } else {
            APIClient.shared.likeImage(withImageId: imageId, completion: completion, failure: failure)
        }
    }
    
    // Configure date formatter
    
    func configureDateFormatter() {
        ImageViewModel.dateFormatter.dateStyle = .medium
        ImageViewModel.dateFormatter.timeStyle = .short
        ImageViewModel.dateFormatter.doesRelativeDateFormatting = true
    }
    
}
