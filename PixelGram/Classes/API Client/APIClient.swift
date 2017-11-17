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
                headers["x-access-token"] = token
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
                
                Session.sharedInstance.email = email
                Session.sharedInstance.currentUser = user
                Session.sharedInstance.token = token
                Session.sharedInstance.password = password
                
                completion()
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
    func autoLogin(completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        let email = Session.sharedInstance.email ?? ""
        let password = Session.sharedInstance.password ?? ""
        
        if email.count < 1 || password.count < 1 {
            failure("Something went wrong. Log in to access your account.")
        } else {
            login(with: email, password: password, completion: completion, failure: failure)
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
    
    func editUser(with id: String, name: String, username: String, email: String, bio: String, avatar: String?, completion: @escaping ResponseBlock, failure: @escaping ErrorBlock) {
        var parameters = [
            "name": name,
            "username": username,
            "email": email,
        ]
        
        if let avatar = avatar {
            parameters["avatar"] = avatar
        }
        
        request(with: "users/\(id)", method: .put, parameters: parameters).responseJSON { [weak self] response in
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                return
            }
            if statusCode == 403 {
                self?.autoLogin(completion: {
                    self?.editUser(with: id, name: name, username: username, email: email, bio: bio, avatar: avatar, completion: completion, failure: failure)
                }, failure: { error in
                    failure(error)
                })
            } else if statusCode == 200 {
                completion(json)
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
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
    
    // MARK: - Image upload
    
    func uploadImage(image: UIImage, completion: @escaping ResponseBlock, failure: @escaping ErrorBlock) {
        guard let imgData = UIImageJPEGRepresentation(image, 0.2) else {
            failure("Could't upload image.")
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: "\(baseURL)/upload/", method: .post, headers: headers) { [weak self] result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard let statusCode = response.response?.statusCode else {
                        return
                    }
                    if statusCode == 403 {
                        self?.autoLogin(completion: {
                            self?.uploadImage(image: image, completion: completion, failure: failure)
                        }, failure: { error in
                            failure(error)
                        })
                    } else if statusCode == 200 {
                        if let json = response.result.value as? [String: AnyObject] {
                            completion(json)
                        }
                    } else {
                        failure("There was an error while uploading image.")
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
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
