//
//  APIClient.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/29/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class APIClient {
    
    typealias ImageCompletion = ([Image]) -> Void
    typealias UserCompletion = (User) -> Void
    typealias CompletionBlock = () -> Void
    typealias ErrorBlock = (Error) -> Void
    
    static let sharedInstance = APIClient()
    
    private init() {}
    
    func login(completion: CompletionBlock, failure: ErrorBlock) {
        
        loadUser(with: "identifier", completion: { (user) in
            Session.sharedInstance.currentUser = user
            Session.sharedInstance.token = "secure-token"
            Session.sharedInstance.authDate = Date()
        }) { (error) in
            
        }
        
        completion()
    }
    
    func logout(completion: CompletionBlock, failure: ErrorBlock) {
        Session.sharedInstance.currentUser = nil
        Session.sharedInstance.token = nil
        Session.sharedInstance.authDate = nil
        
        completion()
    }
    
    func loadUser(with id: String, completion: UserCompletion, failure: ErrorBlock) {
        
        if let user = MockServer.sharedInstance.users.first {
            completion(user)
        } else {
            print("Loading user failed, network errors will be passed here")
        }
    }
    
    func loadImages(for page: Int, limit: Int, completion: ImageCompletion,
                    failure: ErrorBlock) {
        
        let images = MockServer.sharedInstance.images
        
        completion(images)
    }
    
    func loadImages(forUser user: User, page: Int, limit: Int,
                    completion: ImageCompletion, failure: ErrorBlock) {
        
        if let images = user.images {
            completion(images)
        }
    }
    
}
