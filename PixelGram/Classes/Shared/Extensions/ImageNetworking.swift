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
        if let manager = SDWebImageManager.shared().imageDownloader {
            manager.setValue(Session.shared.token, forHTTPHeaderField: "x-access-token")
        }
        sd_setImage(with: url)
    }
    
}
