//
//  FeedViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeader()
        
        title = "Feed"
    }
    
    func setupHeader() {
        let logoView = UIImageView()
        let image = UIImage(named: "logo")
        let ratio: CGFloat = (image?.size.width ?? 0) / (image?.size.height ?? 1)
        
        let height: CGFloat = 30.0;
        let size = CGSize(width: height * ratio, height: height)
        logoView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        logoView.image = image
        
        let titleView = UIView()
        titleView.addSubview(logoView)
        logoView.center = titleView.center
        
        self.navigationItem.titleView = titleView
    }

}
