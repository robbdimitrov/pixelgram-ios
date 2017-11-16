//
//  MockServer.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/30/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

// Contains hardcoded data
class MockServer {

    static let sharedInstance = MockServer()
    
    var images = [Image]()
    var users = [User]()
    
    private init() {
        generateData()
    }
    
    // Generators
    
    func generateData() {
        // Generate users
        
//        let user1 = User(name: "Peter Heim",
//                        username: "peterH",
//                        email: "peterH@mail.com",
//                        avatarURL: "https://3.bp.blogspot.com/-ruB-4ADEKGI/WRBQU5CyU2I/AAAAAAAAANs/AlT6lpWnyMw805vvXLztCQzwk2aeJkRiwCLcB/s320/Cool+Whatsapp+Pics.png",
//                        bio: "Smart guy, founder @WorldCo. Loves travel, great cuisine and looking at the stars.")
//
//        let user2 = User(name: "Joan of Arc",
//                         username: "joahnn",
//                         email: "joahnn@mail.com",
//                         avatarURL: "https://media.vanityfair.com/photos/592d878a8ebae30963f0265b/master/pass/silicon-valley-haley-joel-osment.jpg",
//                         bio: "Designer @facebook")
//
//        let user3 = User(name: "Smart Pants",
//                         username: "smarty",
//                         email: "sPants@mail.com",
//                         avatarURL: "https://pbs.twimg.com/profile_images/822420954324365312/D1iNOqmR_400x400.jpg",
//                         bio: "Comedian actor, flower lover")
//
//        let user4 = User(name: "Mich Connor",
//                         username: "michconnor",
//                         email: "mich_c@mail.com",
//                         avatarURL: "http://www.replify.com/wp-content/uploads/2016/05/A11442-illustration-of-a-cartoon-elephant-pv-1.jpg",
//                         bio: "Creative guru, fitness nut, #vegan")
//
//        users = [user1, user2, user3, user4]
//
//        var imageDescriptions = [
//            "My beautiful tiny puppy. Love it very very very much. Say hello puppy =) #sweet #pup",
//            "Rox in the gardern. Playing with the flowers #life",
//            "My dog. 6 years old #timeflies",
//            "Lovely day, all day outside with my best pal"
//        ]
//
//        let imageURLs = [
//            "https://static.pexels.com/photos/356378/pexels-photo-356378.jpeg",
//            "https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_960_720.jpg",
//            "https://static.pexels.com/photos/33053/dog-young-dog-small-dog-maltese.jpg",
//            "https://static.pexels.com/photos/59523/pexels-photo-59523.jpeg",
//            "https://i.ytimg.com/vi/SfLV8hD7zX4/maxresdefault.jpg",
//            "https://d2wq73xazpk036.cloudfront.net/media/27FB7F0C-9885-42A6-9E0C19C35242B5AC/62E3C530-E8C8-445A-B6EA56249F2436C8/thul-f04490c1-9934-5e1b-a40e-a43b203cb1ed.jpg?response-content-disposition=inline",
//            "http://www.petmd.com/sites/default/files/husky.jpg",
//            "http://cdn.skim.gs/images/v1/msi/oqxdhhql56dg4wyotqtd/worst-dog-breeds-for-kids-with-allergies",
//            "https://lifeplunge.com/wp-content/uploads/2016/06/akita1-750x410-1.jpg",
//            "http://www.petmd.com/sites/default/files/petmd-american-dogs.jpg",
//            "https://www.outsideonline.com/sites/default/files/migrated-images_parent/migrated-images_16/tibetan-mastiff-most-expensive_ph.jpg",
//            "http://www.petmd.com/sites/default/files/clean-dog-breeds-bedlington.jpg",
//            "https://i.pinimg.com/736x/96/a1/26/96a12699a73724012b246d64abc148aa--cute-dog-breeds-family-dog-breeds.jpg"
//        ]
//
//        let likedArrays = [
//            [user1, user2],
//            [user2, user3, user1],
//            [user4],
//            []
//        ]
//
//        for url in imageURLs {
//            let index = Int(arc4random_uniform(UInt32(users.count)))
//            let user = users[index]
//            let description = imageDescriptions[index]
//
//            let image = Image(owner: user,
//                              url: url,
//                              dateCreated: Date(),
//                              description: description,
//                              usersLiked: likedArrays[index])
//            images.append(image)
//            user.images?.append(image)
//
//            for user in image.usersLiked! {
//                user.likedImages?.append(image)
//            }
//        }
    }
    
}
