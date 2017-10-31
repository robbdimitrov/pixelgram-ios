//
//  FeedViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FeedViewController: CollectionViewController {

    private var viewModel = FeedViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        }
    }
    
    // MARK: - Config
    
    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = "Feed"
        if let image = UIImage(named: "logo") {
            setupTitleView(with: image)
        }
    }
    
    func configureCollectionView() {
        guard let collectionView = collectionView else {
            print("Error: collection view is nil")
            return
        }
        
        viewModel.imagesObservable
            .bind(to: collectionView.rx.items(cellIdentifier:
            ImageViewCell.reuseIdentifier,
            cellType: ImageViewCell.self)) { (row, element, cell) in
                
                cell.configure(with: ImageViewModel(with: element))
                
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    func openUserProfile() {
        let viewController = instantiateViewController(withIdentifier:
            ProfileViewController.storyboardIdentifier)
        
        navigationController?.pushViewController(viewController, animated: true)
    }

}
