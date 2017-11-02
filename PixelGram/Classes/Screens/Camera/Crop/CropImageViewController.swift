//
//  CropImageViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/1/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit
import Photos

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
