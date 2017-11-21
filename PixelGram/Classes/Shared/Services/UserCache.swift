//
//  UserCache.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/19/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class UserCache {

    static let shared = UserCache()
    
    private var users = [String:User]()
    
    subscript(id: String) -> User? {
        get {
            return users[id]
        }
        set {
            users[id] = newValue
        }
    }
    
    private init() {}
    
    func deleteCache() {
        users.removeAll()
    }

}
