//
//  ImageViewCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class ImageViewCell: FullWidthCell {
    
    @IBOutlet var avatarImageView: UIImageView? {
        didSet {
            avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.width ?? 0) / 2.0
        }
    }
    @IBOutlet var usernameLabel: UILabel?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var likesLabel: UILabel?
    @IBOutlet var likeButton: UIButton?
    @IBOutlet var shareButton: UIButton?
    @IBOutlet var descriptionLabel: UILabel?
    @IBOutlet var dateCreatedLabel: UILabel?
    
    var viewModel: ImageViewModel?
    
    // MARK: - Config
    
    func configure(with viewModel: ImageViewModel) {
        self.viewModel = viewModel
        
        if let ownerAvatarURL = viewModel.ownerAvatarURL {
            avatarImageView?.setImage(with: ownerAvatarURL)
        } else {
            // Use placeholder image
        }
        if let imageURL = viewModel.imageURL {
            imageView?.setImage(with: imageURL)
        }
        usernameLabel?.text = viewModel.usernameText
        likesLabel?.text = viewModel.likesText
        descriptionLabel?.attributedText = viewModel.descriptionText
        dateCreatedLabel?.text = viewModel.dateCreatedText
    }
    
}
