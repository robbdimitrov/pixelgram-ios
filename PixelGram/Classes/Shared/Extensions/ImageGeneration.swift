//
//  ImageGeneration.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/2/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

extension UIImage {

    class func image(with color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    class func backgroundImageWithShadow(color: UIColor, shadowColor: UIColor, size: CGSize, shadowSize: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        shadowColor.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0, y: rect.height - shadowSize.height), size: shadowSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

}
