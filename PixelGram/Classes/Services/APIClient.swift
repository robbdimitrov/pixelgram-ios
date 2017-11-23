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
    
    // MARK: - Notifications
    
    static let NetworkConnectionFailedNotification = "NewtorkConnectionFailedNotificationName"
    static let UserLoggedInNotification = "UserLoggedInNotificationName"
    static let UserLoggedOutNotification = "UserLoggedOutNotificationName"
    
    // MARK: - Response status codes
    
    enum APIStatusCode: Int {
        case ok = 200
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
    }
    
    // MARK: - Completion types
    
    typealias ImageCompletion = ([Image]) -> Void
    typealias UserCompletion = (User) -> Void
    typealias UsersCompletion = ([User]) -> Void
    typealias CompletionBlock = () -> Void
    typealias ResponseBlock = ([String: AnyObject]?) -> Void
    typealias ErrorBlock = (String) -> Void
    
    // MARK: - Properties
    
    static let shared = APIClient()
    
    private let baseURL = "http://localhost:3000/api/v1.0"
    
    private var headers: HTTPHeaders {
        get {
            var headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            if let token = Session.shared.token {
                headers["x-access-token"] = token
            }
            return headers
        }
    }
    
    private init() {}
    
    // MARK: - Internal
    
    private func handleNewtorkError(error: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: APIClient.NetworkConnectionFailedNotification),
                                        object: self, userInfo: ["error": error])
    }
    
    private func request(withURL url: String, method: HTTPMethod, parameters: Parameters? = nil) -> DataRequest {
        return Alamofire.request("\(baseURL)/\(url)", method: method, parameters: parameters,
                                 encoding: URLEncoding.httpBody, headers: headers)
    }
    
    private func autoLogin(completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        let email = Session.shared.email ?? ""
        let password = Session.shared.password ?? ""
        
        if email.count < 1 || password.count < 1 {
            failure("Something went wrong. Log in to access your account.")
        } else {
            login(withEmail: email, password: password, completion: completion, failure: failure)
        }
    }
    
    // MARK: - Authentication
    
    func login(withEmail email: String, password: String, completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        let parameters = [
            "email": email,
            "password": password
        ]
        
        NetworkActivity.shared.pushTask()
        
        request(withURL: "sessions", method: .post, parameters: parameters).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.ok.rawValue, let dictionary = json["user"] as? [String: AnyObject], let token = json["token"] as? String {
                let user = UserFactory.createUser(dictionary)
                
                Session.shared.email = email
                Session.shared.currentUser = user
                Session.shared.token = token
                Session.shared.password = password
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: APIClient.UserLoggedInNotification),
                                                object: self, userInfo: ["user": user])
                
                UserCache.shared[user.id] = user
                
                completion()
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
                
                if statusCode == APIStatusCode.unauthorized.rawValue {
                    self?.logout(completion: nil)
                }
            }
        }
    }
    
    func logout(completion: CompletionBlock?) {
        Session.shared.currentUser = nil
        Session.shared.email = nil
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: APIClient.UserLoggedOutNotification),
                                        object: self, userInfo: nil)
        
        completion?()
    }
    
    // MARK: - Users
    
    func createUser(name: String, username: String, email: String, password: String, completion: @escaping ResponseBlock, failure: @escaping ErrorBlock) {
        let parameters = [
            "name": name,
            "username": username,
            "email": email,
            "password": password
        ]
        
        NetworkActivity.shared.pushTask()
        
        request(withURL: "users", method: .post, parameters: parameters).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
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
    
    func loadUser(withId userId: String, completion: @escaping UserCompletion, failure: @escaping ErrorBlock) {
        NetworkActivity.shared.pushTask()
        
        request(withURL: "users/\(userId)", method: .get).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.loadUser(withId: userId, completion: completion, failure: failure)
                }, failure: { error in
                    failure(error)
                })
            } else if statusCode == APIStatusCode.ok.rawValue {
                if let jsonUser = json["user"] as? [String: AnyObject] {
                    let user = UserFactory.createUser(jsonUser)
                    UserCache.shared[user.id] = user
                    completion(user)
                }
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
    func editUser(withId userId: String, name: String, username: String, email: String, bio: String, avatar: String?, completion: @escaping ResponseBlock, failure: @escaping ErrorBlock) {
        var parameters = [
            "name": name,
            "username": username,
            "email": email,
            "bio": bio
        ]
        
        if let avatar = avatar {
            parameters["avatar"] = avatar
        }
        
        NetworkActivity.shared.pushTask()
        
        request(withURL: "users/\(userId)", method: .put, parameters: parameters).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.editUser(withId: userId, name: name, username: username, email: email, bio: bio, avatar: avatar, completion: completion, failure: failure)
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
    
    func changePassword(forUserId userId: String, oldPassword: String, password: String, completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        let parameters = [
            "oldPassword": oldPassword,
            "password": password
        ]
        
        NetworkActivity.shared.pushTask()
        
        request(withURL: "users/\(userId)", method: .put, parameters: parameters).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.changePassword(forUserId: userId, oldPassword: oldPassword, password: password, completion: completion, failure: failure)
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
    
    func loadUsersLikedImage(withId imageId: String, page: Int, limit: Int = 25, completion: @escaping UsersCompletion, failure: @escaping ErrorBlock) {
        NetworkActivity.shared.pushTask()
        
        request(withURL: "images/\(imageId)/likes?page=\(page)&limit=\(limit)", method: .get).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.loadUsersLikedImage(withId: imageId, page: page, limit: limit, completion: completion, failure: failure)
                }, failure: { error in
                    failure(error)
                })
            } else if statusCode == APIStatusCode.ok.rawValue {
                if let jsonImages = json["likes"] as? [[String: AnyObject]] {
                    var users = [User]()
                    for dictionary in jsonImages {
                        let user = UserFactory.createUser(dictionary)
                        UserCache.shared[user.id] = user
                        users.append(user)
                    }
                    completion(users)
                }
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
    // MARK: - Image upload
    
    func uploadImage(_ image: UIImage, completion: @escaping ResponseBlock, failure: @escaping ErrorBlock) {
        guard let imgData = UIImageJPEGRepresentation(image, 0.2) else {
            failure("Could't upload image.")
            return
        }
        
        NetworkActivity.shared.pushTask()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: "\(baseURL)/upload/", method: .post, headers: headers) { [weak self] result in
            NetworkActivity.shared.popTask()
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard let statusCode = response.response?.statusCode else {
                        if let error = response.result.error?.localizedDescription {
                            self?.handleNewtorkError(error: error)
                        }
                        
                        return
                    }
                    if statusCode == APIStatusCode.unauthorized.rawValue {
                        self?.autoLogin(completion: {
                            self?.uploadImage(image, completion: completion, failure: failure)
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
    
    private func loadImages(withURL url: String, completion: @escaping ImageCompletion, failure: @escaping ErrorBlock) {
        NetworkActivity.shared.pushTask()

        request(withURL: url, method: .get).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()

            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }

                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.loadImages(withURL: url, completion: completion, failure: failure)
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

    func loadImages(forPage page: Int, limit: Int = 10,
                    completion: @escaping ImageCompletion, failure: @escaping ErrorBlock) {
        let url = "images?page=\(page)?limit=\(limit)"
        loadImages(withURL: url, completion: completion, failure: failure)
    }
    
    func loadImages(forUserId userId: String, likes: Bool = false, page: Int, limit: Int = 10,
                    completion: @escaping ImageCompletion, failure: @escaping ErrorBlock) {
        let destination = likes ? "likes" : "images"
        let url = "users/\(userId)/\(destination)?page=\(page)?limit=\(limit)"
        loadImages(withURL: url, completion: completion, failure: failure)
    }
    
    func loadImage(withId imageId: String, completion: @escaping ImageCompletion, failure: @escaping ErrorBlock) {
        NetworkActivity.shared.pushTask()
        
        request(withURL: "images/\(imageId)", method: .get).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.loadImage(withId: imageId, completion: completion, failure: failure)
                }, failure: { error in
                    failure(error)
                })
            } else if statusCode == APIStatusCode.ok.rawValue {
                if let jsonImage = json["image"] as? [String: AnyObject] {
                    let image = ImageFactory.createImage(jsonImage)
                    
                    completion([image])
                }
            } else {
                let error = json["error"]
                failure((error as? String) ?? "Error")
            }
        }
    }
    
    func createImage(filename: String, description: String, completion: @escaping ResponseBlock, failure: @escaping ErrorBlock) {
        let parameters = [
            "filename": filename,
            "description": description
        ]
        
        NetworkActivity.shared.pushTask()
        
        request(withURL: "images", method: .post, parameters: parameters).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.createImage(filename: filename, description: description, completion: completion, failure: failure)
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
    
    func deleteImage(withId imageId: String, completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        NetworkActivity.shared.pushTask()
        
        request(withURL: "images/\(imageId)", method: .delete).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.deleteImage(withId: imageId, completion: completion, failure: failure)
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
    
    func likeImage(withImageId imageId: String, completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        NetworkActivity.shared.pushTask()
        
        request(withURL: "images/\(imageId)/likes", method: .post).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.likeImage(withImageId: imageId, completion: completion, failure: failure)
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
    
    func dislikeImage(withUserId userId: String, imageId: String, completion: @escaping CompletionBlock, failure: @escaping ErrorBlock) {
        NetworkActivity.shared.pushTask()
        
        request(withURL: "images/\(imageId)/likes/\(userId)", method: .delete).responseJSON { [weak self] response in
            NetworkActivity.shared.popTask()
            
            guard let statusCode = response.response?.statusCode, let json = response.result.value as? [String: AnyObject] else {
                if let error = response.result.error?.localizedDescription {
                    self?.handleNewtorkError(error: error)
                }
                
                return
            }
            if statusCode == APIStatusCode.unauthorized.rawValue {
                self?.autoLogin(completion: {
                    self?.dislikeImage(withUserId: userId, imageId: imageId, completion: completion, failure: failure)
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
    
}
