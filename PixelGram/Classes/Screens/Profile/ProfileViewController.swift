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
    private var page: Int = 0
    var userId: String?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialHeaderSize()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userId == nil {
            userId = Session.sharedInstance.currentUser?.id
            refreshUser { [weak self] in
                self?.collectionView?.reloadData()
            }
            
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: APIClient.UserLoggedOutNotification), object: nil, queue: nil, using: { [weak self] notification in
                self?.viewModel = nil
                self?.userId = nil
                self?.page = 0
                self?.navigationController?.popToRootViewController(animated: false)
                if let strongSelf = self {
                    NotificationCenter.default.removeObserver(strongSelf)
                }
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellSide: CGFloat = collectionView.frame.width / 2
            flowLayout.estimatedItemSize = CGSize(width: cellSide, height: cellSide)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Data
    
    override func handleRefresh(_ sender: UIRefreshControl) {
        refreshUser { [weak sender, weak self] in
            sender?.endRefreshing()
            self?.collectionView?.reloadData()
        }
    }
    
    func refreshUser(completionBlock: (() -> Void)?) {
        guard let id = userId else {
            return
        }
        APIClient.sharedInstance.loadUser(with: id, completion: { [weak self] user in
            self?.createViewModel(with: user)
            self?.loadPosts(for: 0, completionBlock: completionBlock)
        }) { [weak self] error in
            self?.showError(error: error)
            completionBlock?()
        }
    }
    
    func loadPosts(for page: Int, limit: Int = 10, completionBlock: (() -> Void)?) {
        APIClient.sharedInstance.loadImages(forUserId: userId ?? "", page: page, limit: limit, completion: { [weak self] images in
            self?.page = page
            
            self?.viewModel?.images.value.append(contentsOf: images)
            
            completionBlock?()
        }) { [weak self] error in
            self?.showError(error: error)
        }
    }
    
    // MARK: - Helpers
    
    func loadNextPage() {
        let oldCount = viewModel?.images.value.count ?? 0
        
        loadPosts(for: page + 1) { [weak self] in
            let count = self?.viewModel?.images.value.count ?? 0
            
            guard count > oldCount else {
                return
            }
            
            var indexPaths = [IndexPath]()
            
            for index in oldCount...count {
                let indexPath = IndexPath(row: index - 1, section: 0)
                indexPaths.append(indexPath)
            }
            
            self?.collectionView?.insertItems(at: indexPaths)
        }
    }
    
    func createViewModel(with user: User) {
        viewModel = ProfileViewModel(with: user)
    }
    
    // MARK: - Components
    
    func createDataSource() -> CollectionViewDataSource {
        let dataSource = SupplementaryElementCollectionViewDataSource(configureHeader: {
            [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView in
                return (self?.configureHeaderCell(collectionView: collectionView, kind: kind, indexPath: indexPath))!
            }, configureCell: { [weak self] (collectionView, indexPath) -> UICollectionViewCell in
                if indexPath.row == (self?.viewModel?.images.value.count ?? 0) - 1 {
                    self?.loadNextPage()
                }
                
                return (self?.configureCell(collectionView: collectionView, indexPath: indexPath))!
            }, numberOfItems: { [weak self] (collectionView, section)  -> Int in
                return self?.viewModel?.numberOfItems ?? 0
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
        (viewController as? EditProfileViewController)?.viewModel = viewModel?.userViewModel
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
