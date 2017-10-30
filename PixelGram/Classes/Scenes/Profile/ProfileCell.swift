//
//  ProfileCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/28/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class ProfileCell: FullWidthCell {
    
    @IBOutlet var avatarImageView: UIImageView? {
        didSet {
            avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.width ?? 0) / 2.0
        }
    }
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var bioLabel: UILabel?
    @IBOutlet var numberImagesLabel: UILabel?
    @IBOutlet var numberLikesLabel: UILabel?
    
    var viewModel: UserViewModel?
    
    func configure(with viewModel: UserViewModel) {
        self.viewModel = viewModel
        
        if let avatarURL = viewModel.avatarURL {
            avatarImageView?.setImage(with: avatarURL)
        } else {
            // Use placeholder image
        }
        nameLabel?.text = viewModel.nameText
        bioLabel?.text = viewModel.bioText
        numberImagesLabel?.text = viewModel.imagesNumberText
        numberLikesLabel?.text = viewModel.likesNumberText
    }
    
}
