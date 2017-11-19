//
//  AppDelegate.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/24/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        return true
    }

}

