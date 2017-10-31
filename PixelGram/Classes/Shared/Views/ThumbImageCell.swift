//
//  ThumbImageCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/30/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class ThumbImageCell: FullWidthCollectionViewCell {
    
    @IBOutlet var imageView: UIImageView?
    
    var viewModel: ImageViewModel?
    
    // MARK: - Config
    
    func configure(with viewModel: ImageViewModel) {
        self.viewModel = viewModel
        
        if let imageURL = viewModel.imageURL {
            imageView?.setImage(with: imageURL)
        }
    }
    
}
