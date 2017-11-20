//
//  UserLoader.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/20/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class UserLoader {

    static let UserLoadedNotification = "UserLoadedNotification"
    
    static let sharedInstance = UserLoader()
    
    private init() {}
    
    func user(withId userId: String) -> User? {
        if let user = UserCache.sharedInstance[userId] {
            return user
        } else {
            loadUser(withId: userId)
        }
        return nil
    }
    
    func loadUser(withId userId: String, completion: APIClient.UserCompletion? = nil, failure: APIClient.ErrorBlock? = nil) {
        APIClient.sharedInstance.loadUser(with: userId, completion: { user in
            NotificationCenter.default.post(name: Notification.Name(rawValue: UserLoader.UserLoadedNotification),
                                            object: self, userInfo: ["userId": userId, "user": user])
            completion?(user)
        }) { error in
            print("Error loading user: \(error)")
            failure?(error)
        }
    }
    
}