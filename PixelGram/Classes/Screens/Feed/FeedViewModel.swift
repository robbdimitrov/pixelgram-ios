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
        case likes
        
        var title: String {
            switch self {
            case .feed:
                return "Feed"
            case .single:
                return "Photo"
            case .likes:
                return "Likes"
            }
        }
    }

    var type = FeedType.feed
    var images = Variable<[Image]>([])
    var page = 0 // Page number (used for data loading)
    
    var loadingFinished: ((Int, Int) -> Void)?
    var loadingFailed: ((String) -> Void)?
    
    var numberOfItems: Int {
        return images.value.count
    }
    
    var title: String {
        return type.title
    }
    
    init(with type: FeedType = .feed, images: [Image] = []) {
        self.type = type
        self.images.value.append(contentsOf: images)
    }
    
    // MARK: - Getters
    
    func imageViewModel(forIndex index: Int) -> ImageViewModel {
        return ImageViewModel(with: images.value[index])
    }
    
    // MARK: - Data loading
    
    func loadData() {
        if type != .single {
            loadImages()
        }
    }
    
    private func loadImages() {
        let oldCount = numberOfItems
        
        let completion: APIClient.ImageCompletion = { [weak self] images in
            if images.count > 0 {
                self?.page += 1
                self?.images.value.append(contentsOf: images)
            }
            
            let count = self?.numberOfItems ?? 0
            
            self?.loadingFinished?(oldCount, count)
        }
        
        let failure: APIClient.ErrorBlock = { [weak self] error in
            print("Loading images failed: \(error)")
            self?.loadingFailed?(error)
        }
        
        if type == .feed {
            APIClient.sharedInstance.loadImages(forPage: page, completion: completion, failure: failure)
        } else if type == .likes, let userId = Session.sharedInstance.currentUser?.id {
            APIClient.sharedInstance.loadImages(forUserId: userId,
                                                likes: true, page: page,
                                                completion: completion, failure: failure)
        }
    }
    
}
