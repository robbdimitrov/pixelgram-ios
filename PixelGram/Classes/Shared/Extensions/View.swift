//
//  View.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/29/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

extension UIView {

    static var reuseIdentifier: String {
        return String(describing: self.self)
    }

}
