//
//  SettingsViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class SettingsViewController: CollectionViewController {

    var viewModel = SettingsViewModel()
    private var dataSource: CollectionViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
    }
    
    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = "Settings"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellSide: CGFloat = collectionView.frame.width
            flowLayout.itemSize = CGSize(width: cellSide, height: 50)
        }
    }
    
    // MARK: - Config
    
    override func configureCollectionView() {
        super.configureCollectionView()
        
        dataSource = createDataSource()
        collectionView?.dataSource = dataSource
        
        collectionView?.rx.itemSelected.bind { [weak viewModel] indexPath in
            viewModel?.performClosure(for: indexPath.item)
        }.disposed(by: disposeBag)
    }
    
    func setupViewModel() {
        viewModel.changePasswordClosure = { [weak self] in
            self?.openChangePassword()
        }
        
        viewModel.likedImagesClosure = { [weak self] in
            self?.openLikedImages()
        }
        
        viewModel.logoutClosure = { [weak self] in
            self?.logout()
        }
        
        viewModel.setupItems()
    }
    
    // MARK: - Components
    
    func createDataSource() -> CollectionViewDataSource {
        let dataSource = CollectionViewDataSource(configureCell: { [weak self]
            (collectionView, indexPath) -> UICollectionViewCell in
                
            return (self?.configureCell(collectionView: collectionView, indexPath: indexPath))!
                
        }, numberOfItems: { [weak viewModel] (collectionView, section)  -> Int in
            return viewModel?.numberOfItems ?? 0
        })
        return dataSource
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? SettingsCell {
            let itemViewModel = viewModel.settingViewModel(forIndex: indexPath.row)
            cell.setup(with: itemViewModel)
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    func openChangePassword() {
        let viewController = instantiateViewController(withIdentifier:
            ChangePasswordViewController.storyboardIdentifier)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openLikedImages() {
        let viewController = instantiateViewController(withIdentifier:
            FeedViewController.storyboardIdentifier)
        
        (viewController as? FeedViewController)?.viewModel = FeedViewModel(with: .likes, images: [])
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func logout() {
        APIClient.shared.logout { [weak self] in
            self?.navigationController?.popViewController(animated: false)
            self?.tabViewController?.handleTabSelection(withSelected: TabViewController.Tab.feed.rawValue)
        }
    }
    
}
