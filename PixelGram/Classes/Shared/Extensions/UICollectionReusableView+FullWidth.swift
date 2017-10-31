//
//  UICollectionReusableView.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

protocol FullWidth {}

extension FullWidth where Self: UICollectionReusableView {
    
    func calculatePreferredLayoutFrame(_ origin: CGPoint, targetWidth: CGFloat) -> CGRect {
        let targetSize = CGSize(width: targetWidth, height: 0)
        
        let horizontalFittingPriority = UILayoutPriority.required
        let verticalFittingPriority = UILayoutPriority.defaultLow
        
        var autoLayoutSize: CGSize
        
        if let contentView = (self as? UICollectionViewCell)?.contentView {
            autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority,
                                                                 verticalFittingPriority: verticalFittingPriority)
        } else {
            autoLayoutSize = systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority,
                                                     verticalFittingPriority: verticalFittingPriority)
        }
        
        let autoLayoutFrame = CGRect(origin: origin, size: autoLayoutSize)
        
        return autoLayoutFrame
    }
    
}

class FullWidthCollectionReusableView: UICollectionReusableView, FullWidth {
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        autoLayoutAttributes.frame = calculatePreferredLayoutFrame(layoutAttributes.frame.origin,
                                                                   targetWidth: layoutAttributes.frame.width)
        
        return autoLayoutAttributes
    }
    
}

class FullWidthCollectionViewCell: UICollectionViewCell, FullWidth {
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        autoLayoutAttributes.frame = calculatePreferredLayoutFrame(layoutAttributes.frame.origin,
                                                                   targetWidth: layoutAttributes.frame.width)
        
        return autoLayoutAttributes
    }
    
}
