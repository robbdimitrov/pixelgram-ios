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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    // Add delegate method, data sources, etc.
    func configureCollectionView() {
        // Implemented by sublclasses
    }
    
}
