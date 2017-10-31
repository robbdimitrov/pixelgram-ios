//
//  CollectionViewDataSource.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {

    typealias CellConfig = (UICollectionView, IndexPath) -> UICollectionViewCell
    typealias NumberOfItems = (UICollectionView, Int) -> Int
    
    var configureCell: CellConfig
    var numberOfItems: NumberOfItems
    
    init(configureCell: @escaping CellConfig,
         numberOfItems: @escaping NumberOfItems) {
        
        self.configureCell = configureCell
        self.numberOfItems = numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return numberOfItems(collectionView, section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return configureCell(collectionView, indexPath)
    }
    
}
