//
//  UIImageView+Sizing.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/3/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

extension UIImageView {

    func imageRect() -> CGRect {
        guard let image = image else {
            return CGRect.zero
        }
        
        let imageSize = image.size
        let imageSizeRatio: CGFloat = imageSize.width / imageSize.height
        
        let width = frame.width
        let height = frame.height
        
        if imageSizeRatio > 1 {
            // horizontal lines
            
            let size = CGSize(width: width, height: width * (1.0 / imageSizeRatio))
            
            return CGRect(origin: CGPoint(x: 0, y: (height / 2.0) - (size.height / 2.0)),
                          size: size)
        } else if imageSizeRatio < 1 {
            // vertical lines
            
            let size = CGSize(width: height * imageSizeRatio, height: height)
            
            return CGRect(origin: CGPoint(x: (width / 2.0) - (size.width / 2.0), y: 0),
                          size: size)
        }
        
        return frame
    }

}
