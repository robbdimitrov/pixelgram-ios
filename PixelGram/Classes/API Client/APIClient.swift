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
    
    func login(completion: () -> Void, failure: (_ error: Error) -> Void) {
        
        loadUser(completion: { (user) in
            Session.sharedInstance.currentUser = user
            Session.sharedInstance.token = "secure-token"
            Session.sharedInstance.authDate = Date()
        }) { (error) in
            
        }
        
        completion()
    }
    
    func logout(completion: () -> Void, failure: (_ error: Error) -> Void) {
        Session.sharedInstance.currentUser = nil
        Session.sharedInstance.token = nil
        Session.sharedInstance.authDate = nil
        
        completion()
    }
    
    func loadUser(completion: (_ user: User) -> Void, failure: (_ error: Error) -> Void) {
        
        var images = [Image]()
        
        var user = User(name: "Peter Heim",
                        username: "peterH",
                        email: "peterh@gmail.com",
                        avatarURL: "https://3.bp.blogspot.com/-ruB-4ADEKGI/WRBQU5CyU2I/AAAAAAAAANs/AlT6lpWnyMw805vvXLztCQzwk2aeJkRiwCLcB/s320/Cool+Whatsapp+Pics.png",
                        bio: "Smart guy, founder @WorldCo",
                        images: [],
                        likedImages: [])
        
        let imageURLs = [
            "https://static.pexels.com/photos/356378/pexels-photo-356378.jpeg",
            "https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_960_720.jpg",
            "https://static.pexels.com/photos/33053/dog-young-dog-small-dog-maltese.jpg",
            "https://static.pexels.com/photos/59523/pexels-photo-59523.jpeg",
            "https://i.ytimg.com/vi/SfLV8hD7zX4/maxresdefault.jpg",
            "https://d2wq73xazpk036.cloudfront.net/media/27FB7F0C-9885-42A6-9E0C19C35242B5AC/62E3C530-E8C8-445A-B6EA56249F2436C8/thul-f04490c1-9934-5e1b-a40e-a43b203cb1ed.jpg?response-content-disposition=inline"
        ]
        
        for url in imageURLs {
            let image = Image(owner: user,
                              url: url,
                              dateCreated: Date(),
                              description: "Dog description",
                              usersLiked: [])
            images.append(image)
        }
        
        user.images = images
        
        completion(user)
    }
    
    func loadImages(for page: Int, limit: Int, completion: (_ images: [Image]) -> Void,
                    failure: (_ error: Error) -> Void) {
        
        var images = [Image]()
        
        let user1 = User(name: "User 1",
                        username: "peterH",
                        email: "peterh@gmail.com",
                        avatarURL: "https://i.pinimg.com/736x/39/42/22/394222ba4866706c7dd60772a96457b3--profile-pictures-to-prove.jpg",
                        bio: "Smart guy, founder @WorldCo",
                        images: [],
                        likedImages: [])
        
        let user2 = User(name: "User 2",
                        username: "peterH",
                        email: "peterh@gmail.com",
                        avatarURL: "https://pbs.twimg.com/profile_images/822420954324365312/D1iNOqmR_400x400.jpg",
                        bio: "Smart guy, founder @WorldCo",
                        images: [],
                        likedImages: [])
        
        let user3 = User(name: "User 3",
                        username: "peterH",
                        email: "peterh@gmail.com",
                        avatarURL: "http://www.replify.com/wp-content/uploads/2016/05/A11442-illustration-of-a-cartoon-elephant-pv-1.jpg",
                        bio: "Smart guy, founder @WorldCo",
                        images: [],
                        likedImages: [])
        
        var users = [user1, user2, user3]
        
        let imageURLs = [
            "https://static.pexels.com/photos/356378/pexels-photo-356378.jpeg",
            "https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_960_720.jpg",
            "https://static.pexels.com/photos/33053/dog-young-dog-small-dog-maltese.jpg",
            "https://static.pexels.com/photos/59523/pexels-photo-59523.jpeg",
            "https://i.ytimg.com/vi/SfLV8hD7zX4/maxresdefault.jpg",
            "https://d2wq73xazpk036.cloudfront.net/media/27FB7F0C-9885-42A6-9E0C19C35242B5AC/62E3C530-E8C8-445A-B6EA56249F2436C8/thul-f04490c1-9934-5e1b-a40e-a43b203cb1ed.jpg?response-content-disposition=inline"
        ]
        
        for url in imageURLs {
            let userIndex = Int(arc4random_uniform(3))
            var user = users[userIndex]
            
            let image = Image(owner: user,
                              url: url,
                              dateCreated: Date(),
                              description: "Dog description",
                              usersLiked: [])
            images.append(image)
            user.images?.append(image)
        }
        
        completion(images)
    }
    
}
