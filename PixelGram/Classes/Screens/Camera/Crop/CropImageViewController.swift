//
//  CropImageViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/1/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit
import Photos

import RxCocoa
import RxSwift

class CropImageViewController: ViewController {
    
    @IBOutlet var imageView: UIImageView?
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    var asset: PHAsset? {
        didSet {
            updateContent()
        }
    }
    var croppedImage: UIImage? {
        guard let image = image else {
            return nil
        }
        guard let croppedCGImage = image.cgImage?.cropping(to: cropArea) else {
            return image
        }
        let croppedImage = UIImage(cgImage: croppedCGImage)
        return croppedImage
    }
    
    var cropArea:CGRect {
        get{
            guard let image = image, let scrollView = scrollView else {
                return CGRect.zero
            }
            
            let imageFrame = imageView?.imageRect() ?? CGRect.zero
            
            let factor = (imageFrame.minX == 0 ? image.size.width / scrollView.frame.width :
                image.size.height / scrollView.frame.height)
            
            let scale = 1 / scrollView.zoomScale
            
            let origin = CGPoint(x: (scrollView.contentOffset.x - imageFrame.origin.x) * scale * factor,
                                 y: (scrollView.contentOffset.y - imageFrame.origin.y) * scale * factor)
            
            let size = CGSize(width: scrollView.frame.size.width * scale * factor,
                              height: scrollView.frame.size.height * scale * factor)
            
            return CGRect(origin: origin, size: size)
        }
    }
    
    @IBOutlet var scrollView: UIScrollView? {
        didSet {
            scrollView?.delegate = self
            scrollView?.minimumZoomScale = 1.0
            scrollView?.maximumZoomScale = 3.0
            
            scrollView?.layer.borderWidth = 1.0
            scrollView?.layer.borderColor = UIColor.buttonColor.cgColor
        }
    }
    
    func setAsset(asset: PHAsset?) {
        if asset === self.asset {
            return
        }
        
        self.asset = asset
    }

    // MARK: Image display
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: (imageView?.bounds.width ?? 0) * scale,
                      height: (imageView?.bounds.height ?? 0) * scale)
    }
    
    func updateContent() {
        guard let asset = asset else {
            return
        }
        
        switch asset.playbackStyle {
        case .image:
            updateStillImage()
            
        default:
            let alertController = UIAlertController(title: "Unsupported Format", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateStillImage() {
        guard let asset = asset else {
            return
        }
        
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.sync {
                
            }
        }
        
        view.window?.showLoadingHUD()
        
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: targetSize,
                                              contentMode: .aspectFit,
                                              options: options,
                                              resultHandler: { [weak self] image, _ in
                                                // Hide the progress view now the request has completed.
                                                
                                                self?.view.window?.hideLoadingHUD()
                                                
                                                // If successful, show the image view and display the image.
                                                guard let image = image else { return }
                                                
                                                self?.image = image
        })
    }
    
}

extension CropImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func centerOrPositionImageContentOffset(scrollView: UIScrollView, targetContentOffset: CGPoint? = nil) -> CGPoint {
        
        let imageFrame = imageView?.imageRect() ?? CGRect.zero
        let visibleFrame = visibleRect(scrollView: scrollView)
        
        var contentOffset = targetContentOffset ?? scrollView.contentOffset
        
        // if image can fit but not centered
        
        if imageFrame.height <= visibleFrame.height {
            let spacing = (visibleFrame.height - imageFrame.height) / 2.0
            
            contentOffset = CGPoint(x: scrollView.contentOffset.x, y: imageFrame.minY - spacing)
        } else if imageFrame.width <= visibleFrame.width {
            let spacing = (visibleFrame.width - imageFrame.width) / 2.0
            
            contentOffset = CGPoint(x: imageFrame.minX - spacing, y: scrollView.contentOffset.x)
        } else {
            // else if outside bounds
            
            if visibleFrame.minX < imageFrame.minX {
                contentOffset.x = imageFrame.minX
            } else if visibleFrame.maxX > imageFrame.maxX {
                contentOffset.x = imageFrame.maxX - visibleFrame.width
            }
            
            if visibleFrame.minY < imageFrame.minY {
                contentOffset.y = imageFrame.minY
            } else if visibleFrame.maxY > imageFrame.maxY {
                contentOffset.y = imageFrame.maxY - visibleFrame.height
            }
        }
        
        return contentOffset
    }
    
    func visibleRect(scrollView: UIScrollView) -> CGRect {
        let origin = scrollView.contentOffset
        let size = scrollView.bounds.size
        
        return CGRect(origin: origin, size: size)
    }
    
    func scrollImageToVisible(scrollView: UIScrollView) {
        let contentOffset = centerOrPositionImageContentOffset(scrollView: scrollView)
        scrollView.setContentOffset(contentOffset, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollImageToVisible(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollImageToVisible(scrollView: scrollView)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollImageToVisible(scrollView: scrollView)
    }
    
}
