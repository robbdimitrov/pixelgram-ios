//
//  ProfileDataSource.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/30/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

typealias CellConfig<Element> = (UICollectionView, IndexPath, Element) -> UICollectionViewCell

class ProfileDataSource: NSObject, UICollectionViewDataSource {
    
    private var configureImageCell: CellConfig<Image>
    private var configureUserCell: CellConfig<User>
    private var viewModel: ProfileViewModel
    
    init(configureUserCell: @escaping CellConfig<User>, configureImageCell: @escaping CellConfig<Image>, viewModel: ProfileViewModel) {
        self.configureUserCell = configureUserCell
        self.configureImageCell = configureImageCell
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.images.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return configureUserCell(collectionView, indexPath, viewModel.user.value)
        }
        let image = viewModel.images.value[indexPath.row]
        return configureImageCell(collectionView, indexPath, image)
    }
    
}
