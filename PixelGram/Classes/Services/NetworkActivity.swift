//
//  NetworkActivity.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/20/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class NetworkActivity {

    static let shared = NetworkActivity()
    
    var numberOfTasks: Int = 0 {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = (numberOfTasks > 0)
        }
    }
    
    private init() {}
    
    func pushTask() {
        numberOfTasks += 1
    }
    
    func popTask() {
        numberOfTasks -= 1
    }

}
