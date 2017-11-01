//
//  GalleryViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/1/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class GalleryViewController: CollectionViewController {

    // MARK: - CollectionView
    
    override func configureCollectionView() {
        super.configureCollectionView()
        
        collectionView?.dataSource = dataSource()
    }
    
    func dataSource() -> CollectionViewDataSource {
        let dataSource = CollectionViewDataSource(configureCell: { (collectionView, indexPath) -> UICollectionViewCell in
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseIdentifier, for: indexPath)
            
        }, numberOfItems: { (collectionView, section) -> Int in
            
            return 1
            
        })
        
        return dataSource
    }

}
