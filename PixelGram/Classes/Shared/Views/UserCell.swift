//
//  UserCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/21/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class UserCell: FullWidthCollectionViewCell {
    
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var usernameLabel: UILabel?
    
    var viewModel: UserViewModel?
    
    // MARK: - Config
    
    func configure(with viewModel: UserViewModel) {
        self.viewModel = viewModel
        
        if let imageURL = viewModel.avatarURL {
            imageView?.setImage(with: imageURL)
        }
        
        nameLabel?.text = viewModel.nameText
        usernameLabel?.text = viewModel.usernameText
    }
    
}
