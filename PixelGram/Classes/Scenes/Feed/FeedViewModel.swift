//
//  FeedViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import RxSwift

class FeedViewModel {

    var images = Variable<[Image]>([])
    
    // Page number (used for data loading)
    var page = 0
    // Limit per page
    var limit = 20
    
    var imagesObservable: Observable<[Image]> {
        return images.asObservable()
    }
    
    func loadData() {
        APIClient.sharedInstance.loadImages(for: page, limit: limit, completion: { [weak self] (images) in
            
            page += 1
            self?.images.value.append(contentsOf: images)
            
        }) { (error) in
            // TODO: Show error
            print("Loading image failed: \(error)")
        }
    }
    
}
