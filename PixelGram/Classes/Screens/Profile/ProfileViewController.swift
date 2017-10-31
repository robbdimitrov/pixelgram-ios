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

class ProfileViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView?
    
    private var viewModel: ProfileViewModel?
    private var dataSource: SupplementaryElementCollectionViewDataSource?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        
        createViewModel()
        configureCollectionView()
        updateHeaderView()
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
    
    // MARK: - Config
    
    func configureInitialHeaderSize() {
        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize =
            CGSize(width: collectionView?.frame.width ?? 10, height: 170)
    }
    
    func updateHeaderView() {
        if let userViewModel = viewModel?.userViewModel {
            configureHeaderView(with: userViewModel.usernameText)
        }
    }
    
    func configureHeaderView(with title: String) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.text = title
        
        navigationItem.titleView = label
    }
    
    func configureCollectionView() {
        guard let viewModel = viewModel else {
            print("Collection view configuration error: viewModel is nil")
            return
        }
        
        guard let collectionView = collectionView else {
            print("Collection view configuration error: collectionView is nil")
            return
        }
        
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

        self.dataSource = dataSource
        collectionView.dataSource = dataSource
    }

}
