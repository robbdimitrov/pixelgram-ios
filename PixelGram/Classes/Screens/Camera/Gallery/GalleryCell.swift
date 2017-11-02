//
//  GalleryCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/1/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class GalleryCell: FullWidthCollectionViewCell {
    
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var selectedView: UIView?
    var representedAssetIdentifier: String!
    
    override var isSelected: Bool {
        didSet {
            selectedView?.alpha = isSelected ? 0.5 : 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        representedAssetIdentifier = ""
        imageView?.image = nil
    }
    
}
