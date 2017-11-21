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

    // MARK: - App lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        setupNetworkNotification()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        removeNetworkNotification()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        removeNetworkNotification()
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        UserCache.shared.deleteCache()
    }
    
    // MARK: - Notifications
    
    func setupNetworkNotification() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: APIClient.NetworkConnectionFailedNotification),
                                               object: APIClient.shared, queue: nil, using: { [weak self] notification in
            if let rootViewController = self?.window?.rootViewController, let error = notification.userInfo?["error"] as? String {
                let alertController = UIAlertController(title: "Network error", message: error, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func removeNetworkNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(rawValue: APIClient.NetworkConnectionFailedNotification),
                                                  object: APIClient.shared)
    }

}

