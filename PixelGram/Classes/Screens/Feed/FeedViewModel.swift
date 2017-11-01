//
//  FeedViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import RxSwift

class FeedViewModel {
    
    enum FeedType: Int {
        case feed
        case single
        
        var title: String {
            switch self {
            case .feed:
                return "Feed"
            case .single:
                return "Photo"
            }
        }
    }

    var type = FeedType.feed
    var images = Variable<[Image]>([])
    
    // Page number (used for data loading)
    var page = 0
    // Limit per page
    var limit = 20
    
    var imagesObservable: Observable<[Image]> {
        return images.asObservable()
    }
    
    var title: String {
        return type.title
    }
    
    init(with type: FeedType = .feed, images: [Image] = []) {
        self.type = type
        self.images.value.append(contentsOf: images)
    }
    
    // MARK: - Data loading
    
    func loadData() {
        if type == .feed {
            loadImages()
        }
    }
    
    func loadImages() {
        APIClient.sharedInstance.loadImages(for: page, limit: limit, completion: { [weak self] images in
            
            page += 1
            self?.images.value.append(contentsOf: images)
            
        }) { error in
            // TODO: Show error
            print("Loading image failed: \(error)")
        }
    }
    
}
