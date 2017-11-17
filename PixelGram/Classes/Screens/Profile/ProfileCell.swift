//
//  ProfileCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/28/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift

class ProfileCell: FullWidthCollectionReusableView {
    
    @IBOutlet var avatarImageView: UIImageView? {
        didSet {
            avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.width ?? 0) / 2.0
        }
    }
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var bioLabel: UILabel?
    @IBOutlet var numberImagesLabel: UILabel?
    @IBOutlet var numberLikesLabel: UILabel?
    @IBOutlet var editProfileButton: UIButton?
    @IBOutlet var settingsButton: UIButton?
    
    var viewModel: UserViewModel?
    
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    func configure(with viewModel: UserViewModel) {
        self.viewModel = viewModel
        
        if let avatarURL = viewModel.avatarURL {
            avatarImageView?.setImage(with: avatarURL)
        } else {
            avatarImageView?.image = UIImage(named: "avatar_placeholder")
        }
        nameLabel?.text = viewModel.nameText
        bioLabel?.text = viewModel.bioText
        numberImagesLabel?.text = viewModel.imagesNumberText
        numberLikesLabel?.text = viewModel.likesNumberText
        
        editProfileButton?.isHidden = !viewModel.isCurrentUser
        settingsButton?.isHidden = !viewModel.isCurrentUser
    }
    
}
