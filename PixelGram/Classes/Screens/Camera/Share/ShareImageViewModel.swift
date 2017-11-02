//
//  ShareImageViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/1/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class ShareImageViewModel {

    private var selectedImage: UIImage
    var caption = ""
    
    var image: UIImage {
        return selectedImage
    }
    
    init(with image: UIImage) {
        selectedImage = image
    }
    
}
