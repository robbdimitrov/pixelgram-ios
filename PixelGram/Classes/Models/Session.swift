//
//  Session.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

import Locksmith

class Session {

    static let sharedInstance = Session()
    
    private init() {}
    
    var email: String? {
        get {
            return UserDefaults.standard.object(forKey: "email") as? String
        }
        set {
            if let email = email {
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: email)
                } catch {
                    print("Error while deleting previous user's credentials: \(error)")
                }
            }
            let defaults = UserDefaults.standard
            if let newValue = newValue {
                defaults.set(newValue, forKey: "email")
            } else {
                defaults.removeObject(forKey: "email")
            }
            defaults.synchronize()
        }
    }
    
    var password: String? {
        get {
            if let email = email, let credentials = Locksmith.loadDataForUserAccount(userAccount: email) {
                return (credentials["password"] as? String) ?? nil
            }
            return nil
        }
        set {
            var credentials: [String: Any]
            
            if let email = email, let lockchainStore = Locksmith.loadDataForUserAccount(userAccount: email) {
                credentials = lockchainStore
            } else {
                credentials = [:]
            }
            
            if let value = newValue, let email = email {
                credentials["password"] = value
                do {
                    try Locksmith.updateData(data: credentials, forUserAccount: email)
                } catch {
                    print("Error while updating token in keychain: \(error)")
                }
            }
        }
    }
    
    var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            
            if let decoded  = defaults.object(forKey: "user") as? Data {
                let user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? User
                return user
            }
            return nil
        }
        set {
            let defaults = UserDefaults.standard
            
            if let value = newValue {
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
                defaults.set(encodedData, forKey: "user")
            } else {
                defaults.removeObject(forKey: "user")
            }
            
            defaults.synchronize()
        }
    }
    
    var token: String? {
        get {
            if let email = email, let credentials = Locksmith.loadDataForUserAccount(userAccount: email) {
                return (credentials["token"] as? String) ?? nil
            }
            return nil
        }
        set {
            var credentials: [String: Any]
            
            if let email = email, let lockchainStore = Locksmith.loadDataForUserAccount(userAccount: email) {
                credentials = lockchainStore
            } else {
                credentials = [:]
            }
            
            if let value = newValue, let email = email {
                credentials["token"] = value
                do {
                    try Locksmith.updateData(data: credentials, forUserAccount: email)
                } catch {
                    print("Error while updating token in keychain: \(error)")
                }
            }
        }
    }

}
