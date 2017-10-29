//
//  fsdfds.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/29/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import Alamofire

extension UIImageView {

    func setImage(with url: URL) {
        Alamofire.request(url).response { [weak self] response in
            if let data = response.data {
                self?.image = UIImage(data: data, scale: 1)
            }
        }
    }
    
}
