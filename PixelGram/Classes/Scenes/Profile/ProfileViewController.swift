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
    
    private let disposeBag = DisposeBag()
    private var viewModel: ProfileViewModel?
    private var dataSource: ProfileDataSource?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        
        createViewModel()
        configureCollectionView()
        updateHeaderView()
        registerCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 0)
            
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
    
    func registerCells() {
        collectionView?.register(ProfileCell.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    
    // MARK: - Config
    
    func updateHeaderView() {
        if let user = viewModel?.user.value {
            configureHeaderView(with: UserViewModel(with: user).usernameText)
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
        
        let dataSource = ProfileDataSource(configureUserCell: { (collectionView, indexPath, user) -> UICollectionViewCell in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath)

            if let cell = cell as? ProfileCell {
                cell.configure(with: UserViewModel(with: user))
            }

            return cell

        }, configureImageCell: { (collectionView, indexPath, image) -> UICollectionViewCell in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbImageCell.reuseIdentifier, for: indexPath)

            if let cell = cell as? ThumbImageCell {
                cell.configure(with: ImageViewModel(with: image))
            }

            return cell

        }, viewModel: viewModel)

        self.dataSource = dataSource
        collectionView.dataSource = dataSource
    }

}
