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
    
    var dataSource: CollectionViewDataSource?
    
    // MARK: - Object lifecycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        setupViewModel()
        setupUserLoadedNotification()
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
        
        if Session.sharedInstance.currentUser == nil {
            let viewController = instantiateViewController(withIdentifier: LoginViewController.storyboardIdentifier)
            present(NavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
    
    // MARK: - Notifications
    
    func setupUserLoadedNotification() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: UserLoader.UserLoadedNotification), object: UserLoader.sharedInstance, queue: nil, using: { [weak self] notification in
            guard let user = notification.userInfo?["user"] as? User else {
                return
            }
            self?.reloadVisibleCells(user.id)
        })
    }
    
    // MARK: - Data
    
    override func handleRefresh(_ sender: UIRefreshControl) {
        viewModel.page = 0
        viewModel.images.value.removeAll()
        viewModel.loadData()
    }
    
    func reloadVisibleCells(_ userId: String) {
        guard let collectionView = collectionView else {
            return
        }
        
        let visibleCells = collectionView.visibleCells
        
        for cell in visibleCells {
            if let cell = cell as? ImageViewCell, cell.viewModel?.image.owner == userId, let indexPath = collectionView.indexPath(for: cell) {
                let imageViewModel = viewModel.imageViewModel(forIndex: indexPath.row)
                cell.configure(with: imageViewModel)
            }
        }
    }
    
    func createDataSource() -> CollectionViewDataSource {
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
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? ImageViewCell {
            let imageViewModel = viewModel.imageViewModel(forIndex: indexPath.row)
            cell.configure(with: imageViewModel)
            
            cell.userButton?.rx.tap.subscribe(onNext: { [weak self, weak imageViewModel] in
                if let userId = imageViewModel?.image.owner {
                    self?.openUserProfile(with: userId)
                }
            }).disposed(by: cell.disposeBag)
            
            cell.optionsButton?.rx.tap.subscribe(onNext: { [weak self] in
                self?.openOptions()
            }).disposed(by: cell.disposeBag)
        }
        return cell
    }
    
    func updateCells(oldCount: Int, count: Int) {
        guard count > oldCount else {
            return
        }
        
        var indexPaths = [IndexPath]()
        
        for index in oldCount...(count - 1) {
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.append(indexPath)
        }
        if oldCount == 0 {
            collectionView?.reloadData()
        } else {
            collectionView?.insertItems(at: indexPaths)
        }
    }
    
    // MARK: - Config
    
    func setupViewModel() {
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
    
    func setupRefreshControl() {
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
    
    func openOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Delete action
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            self?.deleteAction()
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteAction() {
        let alertController = UIAlertController(title: "Delete Post?", message: "Do you want to delete the post permanently?",
                                                preferredStyle: .alert)
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Delete action
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { action in
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    func openUserProfile(with userId: String) {
        let viewController = instantiateViewController(withIdentifier:
            ProfileViewController.storyboardIdentifier)
        (viewController as? ProfileViewController)?.userId = userId
        navigationController?.pushViewController(viewController, animated: true)
    }

}
