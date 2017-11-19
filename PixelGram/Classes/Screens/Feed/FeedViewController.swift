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
    
    // MARK: - View lifecycle
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Session.sharedInstance.currentUser == nil {
            let viewController = instantiateViewController(withIdentifier: LoginViewController.storyboardIdentifier)
            present(NavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
    
    // MARK: - Config
    
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
        
        viewModel.imagesObservable
            .bind(to: collectionView.rx.items(cellIdentifier:
            ImageViewCell.reuseIdentifier,
            cellType: ImageViewCell.self)) { [weak self] (row, element, cell) in
                
                cell.configure(with: ImageViewModel(with: element))
                
                cell.userButton?.rx.tap.subscribe(onNext: { [weak element] in
//                    if let user = element?.owner {
//                        self?.openUserProfile(with: user)
//                    }
                }).disposed(by: cell.disposeBag)
                
                cell.optionsButton?.rx.tap.subscribe(onNext: { [weak self] in
                    self?.openOptions()
                }).disposed(by: cell.disposeBag)
                
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    func openOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            self?.deleteAction()
        }
        alertController.addAction(destroyAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteAction() {
        let alertController = UIAlertController(title: "Delete Post?", message: "Do you want to delete the post permanently?",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    func openUserProfile(with user: User) {
        let viewController = instantiateViewController(withIdentifier:
            ProfileViewController.storyboardIdentifier)
        
        (viewController as? ProfileViewController)?.viewModel = ProfileViewModel(with: user)
        
        navigationController?.pushViewController(viewController, animated: true)
    }

}
