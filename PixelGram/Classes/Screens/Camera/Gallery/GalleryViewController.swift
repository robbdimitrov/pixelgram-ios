//
//  GalleryViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/1/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit
import Photos

import RxSwift
import RxCocoa

//
// Note: based on Apple's Photos framework sample
// https://developer.apple.com/library/content/samplecode/UsingPhotosFramework/Introduction/Intro.html
//

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

class GalleryViewController: CollectionViewController {
    
    struct SelectedAsset {
        let asset: PHAsset
        let assetCollection: PHAssetCollection
    }

    var fetchResult: PHFetchResult<PHAsset>?
    var assetCollection: PHAssetCollection?
    
    let imageManager = PHCachingImageManager()
    var thumbnailSize = CGSize.zero
    var previousPreheatRect = CGRect.zero
    var selectedAsset: SelectedAsset? {
        guard let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first else {
            return nil
        }
        
        guard let asset = fetchResult?.object(at: selectedIndexPath.item), let assetCollection = assetCollection else {
            return nil
        }
        
        return SelectedAsset(asset: asset,
                             assetCollection: assetCollection)
    }
    
    var dataSource: CollectionViewDataSource?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetCachedAssets()
        
        // If we get here without a segue, it's because we're visible at app launch,
        // so match the behavior of segue from the default "All Photos" view.
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateItemSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCachedAssets()
        if (fetchResult?.count ?? 0) > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
    // MARK: - Helpers
    
    private func updateItemSize() {
        let viewWidth = view.bounds.size.width
        
        let desiredItemWidth: CGFloat = 100
        let columns: CGFloat = max(floor(viewWidth / desiredItemWidth), 4)
        let padding: CGFloat = 1
        let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
        }
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: itemSize.width * scale, height: itemSize.height * scale)
    }
    
    // MARK: - Reactive
    
    func setupObservers() {
        collectionView?.rx.didScroll.bind { [weak self] in
            self?.updateCachedAssets()
        }.disposed(by: disposeBag)
    }
    
    // MARK: - CollectionView
    
    override func configureCollectionView() {
        super.configureCollectionView()
        
        let dataSource = createDataSource()
        collectionView?.dataSource = dataSource
        self.dataSource = dataSource
        
        setupObservers()
    }
    
    func createDataSource() -> CollectionViewDataSource {
        let dataSource = CollectionViewDataSource(configureCell: { [weak self] (collectionView, indexPath) -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseIdentifier, for: indexPath)
            
            if let cell = cell as? GalleryCell {
                self?.configureCell(cell, forIndexPath: indexPath)
            }
            
            return cell
            
        }, numberOfItems: { [weak self] (collectionView, section) -> Int in
            return self?.fetchResult?.count ?? 0
        })
        
        return dataSource
    }
    
    func configureCell(_ cell: GalleryCell, forIndexPath indexPath: IndexPath) {
        guard let asset = fetchResult?.object(at: indexPath.item) else {
            return
        }
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
                cell.imageView?.image = image
            }
        })
    }
    
    // MARK: - Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else {
            return
        }
        
        guard let fetchResult = fetchResult else {
            return
        }
        
        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }

}
