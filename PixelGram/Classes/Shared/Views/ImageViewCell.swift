//
//  ImageViewCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet var avatarImageView: UIImageView?
    @IBOutlet var usernameLabel: UILabel?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var likesLabel: UILabel?
    @IBOutlet var likeButton: UIButton?
    @IBOutlet var shareButton: UIButton?
    
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
    }
    
    // MARK: - Actions
    
    @IBAction func imageDoubleTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        
    }
    
}
