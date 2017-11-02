//
//  UIWindow+HUD.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/2/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import MBProgressHUD

extension UIWindow {

    func showLoadingHUD(_ animated: Bool = true) {
        MBProgressHUD.showAdded(to: self, animated: true)
    }
    
    func hideLoadingHUD(_ animated: Bool = true) {
        MBProgressHUD.hide(for: self, animated: true)
    }

}
