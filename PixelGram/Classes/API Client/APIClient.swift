//
//  APIClient.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/29/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class APIClient {
    
    static let sharedInstance = APIClient()
    
    private init() {}
    
    func login(completion: () -> Void, failure: (Error) -> Void) {
        
        loadUser(with: "identifier", completion: { (user) in
            Session.sharedInstance.currentUser = user
            Session.sharedInstance.token = "secure-token"
            Session.sharedInstance.authDate = Date()
        }) { (error) in
            
        }
        
        completion()
    }
    
    func logout(completion: () -> Void, failure: (Error) -> Void) {
        Session.sharedInstance.currentUser = nil
        Session.sharedInstance.token = nil
        Session.sharedInstance.authDate = nil
        
        completion()
    }
    
    func loadUser(with id: String, completion: (User) -> Void, failure: (Error) -> Void) {
        
        if let user = MockServer.sharedInstance.users.first {
            completion(user)
        } else {
            print("Loading user failed, network errors will be passed here")
        }
    }
    
    func loadImages(for page: Int, limit: Int, completion: ([Image]) -> Void,
                    failure: (_ error: Error) -> Void) {
        
        let images = MockServer.sharedInstance.images
        
        completion(images)
    }
    
}
