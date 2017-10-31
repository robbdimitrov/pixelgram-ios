//
//  ProfileViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ProfileViewController: CollectionViewController {

    private var viewModel: ProfileViewModel?
    private var dataSource: CollectionViewDataSource?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        createViewModel()
        
        super.viewDidLoad()
        
        configureCollectionView()
        configureInitialHeaderSize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellSide: CGFloat = collectionView.frame.width / 2
            flowLayout.estimatedItemSize = CGSize(width: cellSide, height: cellSide)
        }
    }
    
    // MARK: - Helpers
    
    func createViewModel() {
        if viewModel == nil, let user = Session.sharedInstance.currentUser {
            // Display current user by default
            viewModel = ProfileViewModel(with: user)
        }
    }
    
    // MARK: - Components
    
    func createDataSource() -> CollectionViewDataSource {
        let dataSource = SupplementaryElementCollectionViewDataSource(configureHeader: {
            [weak viewModel] (collectionView, kind, indexPath) -> UICollectionReusableView in
            
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: ProfileCell.reuseIdentifier,
                                                                       for: indexPath)
            
            if let cell = cell as? ProfileCell, let userViewModel = viewModel?.userViewModel {
                cell.configure(with: userViewModel)
            }
            
            let size = cell.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: 1000),
                                                    withHorizontalFittingPriority: .required,
                                                    verticalFittingPriority: .defaultLow)
            
            
            (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = size
            
            return cell
            
            }, configureCell: { [weak viewModel] (collectionView, indexPath) -> UICollectionViewCell in
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbImageCell.reuseIdentifier, for: indexPath)
                
                if let cell = cell as? ThumbImageCell, let imageViewModel = viewModel?.imageViewModel(forIndex: indexPath.row) {
                    cell.configure(with: imageViewModel)
                }
                
                return cell
                
            }, numberOfItems: { [weak viewModel] (collectionView, section)  -> Int in
                return viewModel?.numberOfItems ?? 0
        })
        return dataSource
    }
    
    // MARK: - Reactive
    
    func bindEditProfileButton(button: UIButton) {
        
    }
    
    func bindSettingsButton(button: UIButton) {
        
    }
    
    // MARK: - Config
    
    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = "Profile"
        updateTitleView()
    }
    
    func configureInitialHeaderSize() {
        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize =
            CGSize(width: collectionView?.frame.width ?? 10, height: 170)
    }
    
    func updateTitleView() {
        if let userViewModel = viewModel?.userViewModel {
            setupTitleView(with: userViewModel.usernameText)
        }
    }
    
    func configureCollectionView() {
        dataSource = createDataSource()

        collectionView?.dataSource = dataSource
    }

}
