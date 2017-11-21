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

    var viewModel = FeedViewModel()
    private var dataSource: CollectionViewDataSource?
    private var selectedIndex: Int?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        setupViewModel()
        setupUserLoadedNotification()
        setupLogoutNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.numberOfItems <= 0 {
            viewModel.loadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayLoginScreen()
    }
    
    // MARK: - Notifications
    
    private func setupLogoutNotification() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: APIClient.UserLoggedInNotification),
                                               object: APIClient.shared, queue: nil, using: { [weak self] notification in
            self?.viewModel.page = 0
            self?.viewModel.images.value.removeAll()
            self?.displayLoginScreen()
        })
    }
    
    private func setupUserLoadedNotification() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: UserLoader.UserLoadedNotification),
                                               object: UserLoader.shared, queue: nil, using: { [weak self] notification in
            guard let user = notification.userInfo?["user"] as? User else {
                return
            }
            self?.reloadVisibleCells(user.id)
        })
    }
    
    // MARK: - Data
    
    override func handleRefresh(_ sender: UIRefreshControl) {
        viewModel.page = 0
        if viewModel.type != .single {
            viewModel.images.value.removeAll()
        }
        viewModel.loadData()
    }
    
    private func reloadVisibleCells(_ userId: String) {
        guard let collectionView = collectionView else {
            return
        }
        
        let visibleCells = collectionView.visibleCells
        
        for cell in visibleCells {
            if let cell = cell as? ImageViewCell, cell.viewModel?.image.owner == userId, let indexPath = collectionView.indexPath(for: cell) {
                setupCell(cell, forIndexPath: indexPath)
            }
        }
    }
    
    private func createDataSource() -> CollectionViewDataSource {
        let dataSource = CollectionViewDataSource(configureCell: { [weak self] (collectionView, indexPath) -> UICollectionViewCell in
            if indexPath.row == (self?.viewModel.images.value.count ?? 0) - 1 {
                self?.viewModel.loadData()
            }
            return (self?.configureCell(collectionView: collectionView, indexPath: indexPath))!
        }, numberOfItems: { [weak self] (collectionView, section)  -> Int in
            return self?.viewModel.numberOfItems ?? 0
        })
        return dataSource
    }
    
    // MARK: - Cells
    
    private func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.reuseIdentifier, for: indexPath)
        setupCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    private func setupCell(_ cell: UICollectionViewCell, forIndexPath indexPath: IndexPath) {
        guard let cell = cell as? ImageViewCell else {
            return
        }
        
        let imageViewModel = viewModel.imageViewModel(forIndex: indexPath.row)
        cell.configure(with: imageViewModel)
        
        cell.userButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.openUserProfile(atIndex: indexPath.row)
        }).disposed(by: cell.disposeBag)
        
        cell.likesButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.openLikedUsers(selectedIndex: indexPath.row)
        }).disposed(by: cell.disposeBag)
        
        cell.optionsButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectedIndex = indexPath.row
            self?.openOptions()
        }).disposed(by: cell.disposeBag)
    }
    
    private func updateCells(oldCount: Int, count: Int) {
        guard let collectionView = collectionView else {
            return
        }
        
        if oldCount == count {
            refreshCells(collectionView: collectionView)
        } else if oldCount < count {
            insertCells(collectionView: collectionView, oldCount: oldCount, count: count)
        } else if oldCount > count {
            collectionView.reloadData()
        }
    }
    
    private func insertCells(collectionView: UICollectionView, oldCount: Int, count: Int) {
        var indexPaths = [IndexPath]()
        
        for index in oldCount...(count - 1) {
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.append(indexPath)
        }
        if oldCount == 0 {
            collectionView.reloadData()
        } else {
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    private func refreshCells(collectionView: UICollectionView) {
        for cell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: cell) {
                setupCell(cell, forIndexPath: indexPath)
            }
        }
    }
    
    // MARK: - Config
    
    private func setupViewModel() {
        viewModel.loadingFinished = { [weak self] (oldCount, count) in
            if self?.collectionView?.refreshControl?.isRefreshing ?? false {
                self?.collectionView?.refreshControl?.endRefreshing()
            }
            self?.updateCells(oldCount: oldCount, count: count)
        }
        
        viewModel.loadingFailed = { [weak self] error in
            self?.showError(error: error)
        }
    }
    
    private func setupRefreshControl() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.refreshControl = refreshControl
    }
    
    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = viewModel.title
        if viewModel.type == .feed, let image = UIImage(named: "logo") {
            setupTitleView(with: image)
        }
    }
    
    override func configureCollectionView() {
        guard let collectionView = collectionView else {
            print("Error: collection view is nil")
            return
        }
        
        let dataSource = createDataSource()
        self.dataSource = dataSource
        collectionView.dataSource = dataSource
    }
    
    // MARK: - Actions
    
    private func displayLoginScreen() {
        if Session.shared.currentUser == nil {
            let viewController = instantiateViewController(withIdentifier: LoginViewController.storyboardIdentifier)
            present(NavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
    
    private func openOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Delete action
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            self?.deleteAction()
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteAction() {
        let alertController = UIAlertController(title: "Delete Post?", message: "Do you want to delete the post permanently?",
                                                preferredStyle: .alert)
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Delete action
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            if let selectedIndex = self?.selectedIndex {
                self?.deleteImage(atIndex: selectedIndex)
                self?.selectedIndex = nil
            }
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteImage(atIndex index: Int) {
        let imageId = viewModel.images.value[index].id
        let indexPath = IndexPath(row: index, section: 0)
        
        view.window?.showLoadingHUD()
        
        APIClient.shared.deleteImage(withId: imageId, completion: { [weak self] in
            self?.view.window?.hideLoadingHUD()
            
            self?.viewModel.images.value.remove(at: index)
            self?.collectionView?.deleteItems(at: [indexPath])
            
            if self?.viewModel.type == .single, self?.viewModel.numberOfItems == 0 {
                self?.navigationController?.popViewController(animated: true)
            }
        }) { [weak self] error in
            self?.view.window?.hideLoadingHUD()
            
            self?.showError(error: error)
        }
    }
    
    // MARK: - Navigation
    
    private func openUserProfile(atIndex index: Int) {
        let imageOwner = viewModel.images.value[index].owner
        openUserProfile(withUserId: imageOwner)
    }
    
    private func openUserProfile(withUserId userId: String) {
        let viewController = instantiateViewController(withIdentifier:
            ProfileViewController.storyboardIdentifier)
        (viewController as? ProfileViewController)?.userId = userId
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openLikedUsers(selectedIndex: Int) {
        let image = viewModel.images.value[selectedIndex]
        
        if image.likes < 1 {
            return
        }
        
        let viewController = instantiateViewController(withIdentifier:
            UsersViewController.storyboardIdentifier)
        (viewController as? UsersViewController)?.viewModel = UsersViewModel(with: image.id)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Object lifecycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
