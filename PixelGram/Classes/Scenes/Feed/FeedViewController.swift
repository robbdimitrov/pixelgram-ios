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

class FeedViewController: UIViewController {

    private var viewModel = FeedViewModel()
    @IBOutlet var collectionView: UICollectionView?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Feed"
        
        setupHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureCollectionView()
        viewModel.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        }
    }
    
    // MARK: - Config
    
    func configureCollectionView() {
        guard let collectionView = collectionView else {
            print("Error: collection view is nil")
            return
        }
        
        viewModel.images.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier:
            ImageViewCell.reuseIdentifier,
            cellType: ImageViewCell.self)) { (row, element, cell) in
                
                cell.configure(with: ImageViewModel(with: element))
                
        }.disposed(by: disposeBag)
    }
    
    func setupHeader() {
        let logoView = UIImageView()
        let image = UIImage(named: "logo")
        let ratio: CGFloat = (image?.size.width ?? 0) / (image?.size.height ?? 1)
        
        let height: CGFloat = 30.0;
        let size = CGSize(width: height * ratio, height: height)
        logoView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        logoView.image = image
        
        let titleView = UIView()
        titleView.addSubview(logoView)
        logoView.center = titleView.center
        
        self.navigationItem.titleView = titleView
    }

}
