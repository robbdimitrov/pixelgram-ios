//
//  APIClient.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/29/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

import Alamofire

class APIClient {
    
    typealias ImageCompletion = ([Image]) -> Void
    typealias UserCompletion = (User) -> Void
    typealias CompletionBlock = () -> Void
    typealias ResponseBlock = ([String: AnyObject]?) -> Void
    typealias ErrorBlock = (String) -> Void
    
    let baseURL = "http://localhost:3000/api/v1.0"
    
    static let sharedInstance = APIClient()
    
    var headers: HTTPHeaders {
        get {
            var headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            if let token = Session.sharedInstance.token {
                headers["token"] = token
            }
            return headers
        }
    }
    
    private init() {}
    
    func request(with url: String, method: HTTPMethod, parameters: Parameters? = nil) -> DataRequest {
        return Alamofire.request("\(baseURL)/\(url)", method: method, parameters: parameters,
                                 encoding: URLEncoding.httpBody, headers: headers)
    }
    
    // MARK: - Authentication
    
    func login(with email: String, password: String, completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        let parameters = [
            "email": email,
            "password": password
        ]
        
        request(with: "sessions", method: .post, parameters: parameters).responseJSON { response in
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                return
            }
            if statusCode == 200, let dictionary = json["user"] as? [String: AnyObject], let token = json["token"] as? String {
                let user = UserFactory.createUser(dictionary)
                
                Session.sharedInstance.currentUser = user
                Session.sharedInstance.token = token
                Session.sharedInstance.email = email
                Session.sharedInstance.password = password
                
                completion()
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
    func logout(completion: CompletionBlock) {
        Session.sharedInstance.currentUser = nil
        Session.sharedInstance.email = nil
        
        completion()
    }
    
    // MARK: - Users
    
    func createUser(name: String, username: String, email: String, password: String, completion: @escaping ResponseBlock, failure: @escaping ErrorBlock) {
        let parameters = [
            "name": name,
            "username": username,
            "email": email,
            "password": password
        ]
        
        request(with: "users", method: .post, parameters: parameters).responseJSON { response in
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                return
            }
            if statusCode == 200 {
                completion(json)
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
    func loadUser(with id: String, completion: UserCompletion, failure: ErrorBlock) {
        request(with: "users/\(id)", method: .get).responseJSON { response in
            
        }
    }
    
    func editUser(with id: String, name: String, username: String, email: String, bio: String, avatar: String, completion: ResponseBlock, failure: ErrorBlock) {
        let parameters = [
            "name": name,
            "username": username,
            "email": email,
        ]
        
        request(with: "users/\(id)", method: .put, parameters: parameters).responseJSON { response in
            
        }
    }
    
    func changePassword(with id: String, oldPassword: String, password: String, completion: CompletionBlock, failure: ErrorBlock) {
        let parameters = [
            "oldPassword": oldPassword,
            "username": password
        ]
        
        request(with: "users/\(id)", method: .put, parameters: parameters).responseJSON { response in
            
        }
    }
    
    // MARK: - Images
    
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
