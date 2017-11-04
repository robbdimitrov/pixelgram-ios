//
//  NavigationController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/2/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage.backgroundImageWithShadow(color: UIColor.white, shadowColor: UIColor.lightGray,
                                                                size: CGSize(width: 1, height: 10),
                                                                shadowSize: CGSize(width: 1, height: 0.5))
        
        navigationBar.setBackgroundImage(backgroundImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 5, 0)), for: .default)
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        
        navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationBar.tintColor = UIColor.buttonSelectedColor
    }

}
