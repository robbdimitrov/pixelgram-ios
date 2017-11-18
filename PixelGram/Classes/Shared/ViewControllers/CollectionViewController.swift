//
//  CollectionViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class CollectionViewController: ViewController {

    @IBOutlet var collectionView: UICollectionView?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(CollectionViewController.handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = .black
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        // Implemented by sublclasses
        sender.endRefreshing()
    }
    
    // Add delegate method, data sources, etc.
    func configureCollectionView() {
        // Implemented by sublclasses
    }
    
}
