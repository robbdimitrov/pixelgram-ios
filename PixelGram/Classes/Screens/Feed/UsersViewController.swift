//
//  UsersViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/21/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class UsersViewController: CollectionViewController {

    var viewModel: UsersViewModel?
    private var dataSource: CollectionViewDataSource?
    private var page: Int = 0
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUsers(for: page) { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: 70)
        }
    }
    
    // MARK: - Data
    
    override func handleRefresh(_ sender: UIRefreshControl) {
        page = 0
        viewModel?.users.removeAll()
        loadUsers(for: page) { [weak self] in
            self?.collectionView?.reloadData()
            if self?.collectionView?.refreshControl?.isRefreshing ?? false {
                self?.collectionView?.refreshControl?.endRefreshing()
            }
        }
    }
    
    func loadUsers(for page: Int, limit: Int = 20, completionBlock: (() -> Void)?) {
        guard let imageId = viewModel?.imageId else {
            return
        }
        APIClient.shared.loadUsersLikedImage(withId: imageId, page: page, limit: limit, completion: { [weak self] users in
            self?.page = page
            self?.viewModel?.users.append(contentsOf: users)
            completionBlock?()
        }) { [weak self] error in
            self?.showError(error: error)
        }
    }
    
    // MARK: - Helpers
    
    func loadNextPage() {
        let oldCount = viewModel?.users.count ?? 0
        
        loadUsers(for: page + 1) { [weak self] in
            let count = self?.viewModel?.users.count ?? 0
            
            guard count > oldCount else {
                return
            }
            
            var indexPaths = [IndexPath]()
            
            for index in oldCount...(count - 1) {
                let indexPath = IndexPath(row: index, section: 0)
                indexPaths.append(indexPath)
            }
            self?.collectionView?.insertItems(at: indexPaths)
        }
    }
    
    // MARK: - Components
    
    func createDataSource() -> CollectionViewDataSource {
        let dataSource = CollectionViewDataSource(configureCell: { [weak self] (collectionView, indexPath) -> UICollectionViewCell in
                if indexPath.row == (self?.viewModel?.users.count ?? 0) - 1 {
                    self?.loadNextPage()
                }
                return (self?.configureCell(collectionView: collectionView, indexPath: indexPath))!
            }, numberOfItems: { [weak self] (collectionView, section)  -> Int in
                return self?.viewModel?.numberOfItems ?? 0
        })
        return dataSource
    }
    
    // MARK: - Cells
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? UserCell, let userViewModel = viewModel?.userViewModel(forIndex: indexPath.row) {
            cell.configure(with: userViewModel)
        }
        return cell
    }
    
    // MARK: - Reactive
    
    func handleCellSelection(collectionView: UICollectionView?) {
        collectionView?.rx.itemSelected.bind { [weak self] indexPath in
            self?.openUserProfile(atIndex: indexPath.item)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    private func openUserProfile(atIndex index: Int) {
        if let userId = viewModel?.users[index].id {
            openUserProfile(withUserId: userId)
        }
    }
    
    private func openUserProfile(withUserId userId: String) {
        let viewController = instantiateViewController(withIdentifier:
            ProfileViewController.storyboardIdentifier)
        (viewController as? ProfileViewController)?.userId = userId
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Config
    
    func setupRefreshControl() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.refreshControl = refreshControl
    }
    
    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = "Likes"
    }
    
    override func configureCollectionView() {
        dataSource = createDataSource()
        collectionView?.dataSource = dataSource
        handleCellSelection(collectionView: collectionView)
    }

}
