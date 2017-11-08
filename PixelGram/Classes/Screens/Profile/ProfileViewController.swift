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

    var viewModel: ProfileViewModel?
    private var dataSource: CollectionViewDataSource?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        createViewModel()
        
        super.viewDidLoad()
        
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
            [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            
                return (self?.configureHeaderCell(collectionView: collectionView, kind: kind, indexPath: indexPath))!
            
            }, configureCell: { [weak self] (collectionView, indexPath) -> UICollectionViewCell in
                
                return (self?.configureCell(collectionView: collectionView, indexPath: indexPath))!
                
            }, numberOfItems: { [weak viewModel] (collectionView, section)  -> Int in
                return viewModel?.numberOfItems ?? 0
        })
        return dataSource
    }
    
    // MARK: - Cells
    
    func configureHeaderCell(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: ProfileCell.reuseIdentifier,
                                                                   for: indexPath)
        
        if let cell = cell as? ProfileCell, let userViewModel = viewModel?.userViewModel {
            cell.configure(with: userViewModel)
            
            bindSettingsButton(button: cell.settingsButton)?.disposed(by: cell.disposeBag)
            bindEditProfileButton(button: cell.editProfileButton)?.disposed(by: cell.disposeBag)
        }
        
        let size = cell.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: 1000),
                                                withHorizontalFittingPriority: .required,
                                                verticalFittingPriority: .defaultLow)
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = size
        
        return cell
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbImageCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? ThumbImageCell, let imageViewModel = viewModel?.imageViewModel(forIndex: indexPath.row) {
            cell.configure(with: imageViewModel)
        }
        
        return cell
    }
    
    // MARK: - Reactive
    
    func bindEditProfileButton(button: UIButton?) -> Disposable? {
        return button?.rx.tap.subscribe(onNext: { [weak self] in
            self?.openEditProfile()
        })
    }
    
    func bindSettingsButton(button: UIButton?) -> Disposable? {
        return button?.rx.tap.subscribe(onNext: { [weak self] in
            self?.openSettings()
        })
    }
    
    func handleCellSelection(collectionView: UICollectionView?) {
        collectionView?.rx.itemSelected.bind { [weak self] indexPath in
            self?.openFeed(withSelected: indexPath.item)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    func openEditProfile() {
        let viewController = instantiateViewController(withIdentifier:
            EditProfileViewController.storyboardIdentifier)
        
        present(NavigationController(rootViewController: viewController),
                animated: true, completion: nil)
    }
    
    func openSettings() {
        let viewController = instantiateViewController(withIdentifier:
            SettingsViewController.storyboardIdentifier)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openFeed(withSelected index: Int) {
        let viewController = instantiateViewController(withIdentifier:
            FeedViewController.storyboardIdentifier)
        
        if let image = viewModel?.images.value[index] {
            (viewController as? FeedViewController)?.viewModel = FeedViewModel(with: .single, images: [image])
        }
        
        navigationController?.pushViewController(viewController, animated: true)
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
    
    override func configureCollectionView() {
        dataSource = createDataSource()

        collectionView?.dataSource = dataSource
        
        handleCellSelection(collectionView: collectionView)
    }

}
