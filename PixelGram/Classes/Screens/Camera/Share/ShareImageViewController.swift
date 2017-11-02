//
//  ShareImageViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/1/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class ShareImageViewController: CollectionViewController {
    
    var dataSource: CollectionViewDataSource?
    var viewModel: ShareImageViewModel? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = cellSize()
        }
    }
    
    // MARK: - CollectionViewController
    
    override func configureCollectionView() {
        super.configureCollectionView()
        
        let dataSource = createDataSource()
        collectionView?.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    func createDataSource() -> CollectionViewDataSource {
        let dataSource = CollectionViewDataSource(configureCell: { [weak self] (collectionView, indexPath) -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubmitImageCell.reuseIdentifier, for: indexPath)
            
            if let cell = cell as? SubmitImageCell {
                self?.configureCell(cell, forIndexPath: indexPath)
            }
            
            return cell
            
        }, numberOfItems: { (collectionView, section) -> Int in
            return 1
        })
        
        return dataSource
    }
    
    // MARK: - Config
    
    func cellSize() -> CGSize {
        return CGSize(width: (collectionView?.bounds.width ?? 0), height: 100)
    }
    
    func configureCell(_ cell: SubmitImageCell, forIndexPath IndexPath: IndexPath) {
        cell.imageView?.image = viewModel?.image
    }

}
