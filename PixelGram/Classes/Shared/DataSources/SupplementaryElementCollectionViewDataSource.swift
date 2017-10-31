//
//  SupplementaryElementCollectionViewDataSource.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/30/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class SupplementaryElementCollectionViewDataSource: CollectionViewDataSource {
    
    typealias HeaderConfig = (UICollectionView, String, IndexPath) -> UICollectionReusableView
    
    var configureHeader: HeaderConfig
    
    init(configureHeader: @escaping HeaderConfig, configureCell: @escaping CellConfig,
         numberOfItems: @escaping NumberOfItems) {
        self.configureHeader = configureHeader
        
        super.init(configureCell: configureCell, numberOfItems: numberOfItems)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind
        kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return configureHeader(collectionView, kind, indexPath)
    }
    
}
