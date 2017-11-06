//
//  ImageNetworking.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/29/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import SDWebImage

extension UIImageView {

    func setImage(with url: URL) {
        sd_setImage(with: url, completed: nil)
    }
    
}
