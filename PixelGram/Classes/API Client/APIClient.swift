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
    
    static let UserLoggedOutNotification = "UserLoggedOutNotification"
    
    enum APIStatusCode: Int {
        case ok = 200
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
    }
    
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
            if statusCode == APIStatusCode.ok.rawValue, let dictionary = json["user"] as? [String: AnyObject], let token = json["token"] as? String {
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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: APIClient.UserLoggedOutNotification),
                                        object: nil, userInfo: nil)
        
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
            if statusCode == APIStatusCode.ok.rawValue {
                completion(json)
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
    func loadUser(with id: String, completion: @escaping UserCompletion, failure: @escaping ErrorBlock) {
        request(with: "users/\(id)", method: .get).responseJSON { [weak self] response in
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.loadUser(with: id, completion: completion, failure: failure)
                }, failure: { error in
                    failure(error)
                })
            } else if statusCode == APIStatusCode.ok.rawValue {
                if let jsonUser = json["user"] as? [String: AnyObject] {
                    let user = UserFactory.createUser(jsonUser)
                    completion(user)
                }
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
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
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.editUser(with: id, name: name, username: username, email: email, bio: bio, avatar: avatar, completion: completion, failure: failure)
                }, failure: { error in
                    failure(error)
                })
            } else if statusCode == APIStatusCode.ok.rawValue {
                completion(json)
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
    func changePassword(with id: String, oldPassword: String, password: String, completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        let parameters = [
            "oldPassword": oldPassword,
            "password": password
        ]
        
        request(with: "users/\(id)", method: .put, parameters: parameters).responseJSON { [weak self] response in
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.changePassword(with: id, oldPassword: oldPassword, password: password, completion: completion, failure: failure)
                }, failure: { error in
                    failure(error)
                })
            } else if statusCode == APIStatusCode.ok.rawValue {
                completion()
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
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
                    if statusCode == APIStatusCode.unauthorized.rawValue {
                        self?.autoLogin(completion: {
                            self?.uploadImage(image: image, completion: completion, failure: failure)
                        }, failure: { error in
                            failure(error)
                        })
                    } else if statusCode == APIStatusCode.ok.rawValue {
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
    
    func urlForImage(_ filename: String) -> String {
        return "\(baseURL)/uploads/\(filename)"
    }
    
    func loadImages(forPage page: Int, limit: Int = 10, completion: ImageCompletion,
                    failure: ErrorBlock) {
        
    }
    
    func loadImages(forUserId userId: String, page: Int, limit: Int = 10,
                    completion: @escaping ImageCompletion, failure: @escaping ErrorBlock) {
        request(with: "users/\(userId)/images?page=\(page)?limit=\(limit)", method: .get).responseJSON { [weak self] response in
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.loadImages(forUserId: userId, page: page, limit: limit, completion: completion, failure: failure)
                }, failure: { error in
                    failure(error)
                })
            } else if statusCode == APIStatusCode.ok.rawValue {
                if let jsonImages = json["images"] as? [[String: AnyObject]] {
                    var images = [Image]()
                    for dictionary in jsonImages {
                        let image = ImageFactory.createImage(dictionary)
                        images.append(image)
                    }
                    completion(images)
                }
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
}
