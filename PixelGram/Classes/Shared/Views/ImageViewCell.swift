//
//  ImageViewCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ImageViewCell: FullWidthCollectionViewCell {
    
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
    @IBOutlet var userButton: UIButton?
    @IBOutlet var optionsButton: UIButton?
    
    private(set) var disposeBag = DisposeBag()
    
    var viewModel: ImageViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    // MARK: - Config
    
    func configure(with viewModel: ImageViewModel) {
        self.viewModel = viewModel
        
        disposeBag = DisposeBag()
        
        if let ownerAvatarURL = viewModel.ownerAvatarURL {
            avatarImageView?.setImage(with: ownerAvatarURL)
        } else {
            avatarImageView?.image = UIImage(named: "avatar_placeholder")
        }
        if let imageURL = viewModel.imageURL {
            imageView?.setImage(with: imageURL)
        }
        usernameLabel?.text = viewModel.usernameText
        likesLabel?.text = viewModel.likesText
        descriptionLabel?.attributedText = viewModel.descriptionText
        dateCreatedLabel?.text = viewModel.dateCreatedText
        
        guard let likeButton = likeButton else {
            return
        }
        
        likeButton.rx.tap.bind { [weak self, weak likeButton] in
            if let currentUser = Session.shared.currentUser {
                self?.viewModel?.likeImage(with: currentUser)
            }
            likeButton?.isSelected = !(likeButton?.isSelected ?? false)
        }.disposed(by: disposeBag)
        
        likeButton.isSelected = viewModel.isLikedByCurrentUser
        
        optionsButton?.isHidden = !viewModel.isOwnedByCurrentUser
    }
    
}
