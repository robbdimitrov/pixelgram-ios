//
//  Session.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class Session {

    static let sharedInstance = Session()
    
    private init() {}
    
    var authDate: Date? {
        get {
            return Date()
        }
        set {
            
        }
    }
    
    var currentUser: User? {
        get {
            return nil
        }
        set {
            // TODO: Save to user defaults
        }
    }
    
    var token: String? {
        get {
            return nil
        }
        set {
            // TODO: Save to keychain
        }
    }

}
