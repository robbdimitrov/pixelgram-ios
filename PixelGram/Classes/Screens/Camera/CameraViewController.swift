//
//  CameraViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/28/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit
import Photos

import RxCocoa
import RxSwift

class CameraViewController: ViewController {

    enum Page: Int {
        case gallery = 0
        case crop
        case share
    }
    
    @IBOutlet var scrollView: UIScrollView?
    
    var galleryViewController: GalleryViewController?
    var cropImageViewController: CropImageViewController?
    var shareViewController: ShareImageViewController?
    
    var authorizationStatus = Variable(PHPhotoLibrary.authorizationStatus())
    
    @IBOutlet var accessDisabledView: PhotoAccessDisabledView? {
        didSet {
            accessDisabledView?.actionButton?.rx.tap
                .subscribe(onNext: { [weak self] in
                self?.openPhotosPrivacySettings()
            }).disposed(by: disposeBag)
        }
    }
    
    var page = Variable(Page.gallery)
    var viewControllers = [UIViewController]()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        observePages()
        observePhotoAuthorizationStatus()
        updateButtonItems(forPage: page.value, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authorizationStatus.value = PHPhotoLibrary.authorizationStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let scrollViewSize = scrollView?.bounds.size ?? CGSize.zero
        
        for viewController in viewControllers {
            let index = viewControllers.index(of: viewController) ?? 0
            
            let frame = CGRect(origin: CGPoint(x: CGFloat(index) * scrollViewSize.width, y: 0), size: scrollViewSize)
            
            viewController.view.frame = frame
        }
        
        scrollView?.contentSize = CGSize(width: CGFloat(viewControllers.count) * scrollViewSize.width,
                                         height: scrollViewSize.height)
    }
    
    // MARK: - Helpers
    
    func openPhotosPrivacySettings() {
        UIApplication.shared.open(URL(string:"App-Prefs:root=Photos")!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Paging
    
    func nextPage(_ currentPage: Page?) {
        let pageValue = currentPage?.rawValue ?? 0
        
        if let page = Page(rawValue: pageValue + 1) {
            self.page.value = page
        }
    }
    
    func previousPage(_ currentPage: Page?) {
        let pageValue = currentPage?.rawValue ?? 0
        
        if let page = Page(rawValue: pageValue - 1) {
            self.page.value = page
        }
    }
    
    func updateButtonItems(forPage page: Page, animated: Bool = true) {
        var leftButton: BarButtonItem
        var rightButton: BarButtonItem
        
        switch page {
        case .gallery:
            leftButton = BarButtonItem(title: "Close", style: .plain, target: nil, action: nil)
            
            leftButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: leftButton.disposeBag)
            
            rightButton = BarButtonItem(title: "Next", style: .plain, target: nil, action: nil)
            
            rightButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.nextPage(self?.page.value)
            }).disposed(by: rightButton.disposeBag)
            
        case .crop:
            leftButton = BarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            
            leftButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.previousPage(self?.page.value)
            }).disposed(by: leftButton.disposeBag)
            
            rightButton = BarButtonItem(title: "Next", style: .plain, target: nil, action: nil)
            
            rightButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.nextPage(self?.page.value)
            }).disposed(by: rightButton.disposeBag)
            
        case .share:
            leftButton = BarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            
            leftButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.previousPage(self?.page.value)
            }).disposed(by: leftButton.disposeBag)
            
            rightButton = BarButtonItem(title: "Share", style: .plain, target: nil, action: nil)
            
            rightButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.uploadAndShare()
            }).disposed(by: rightButton.disposeBag)
        }
        
        navigationItem.setLeftBarButton(leftButton, animated: animated)
        navigationItem.setRightBarButton(rightButton, animated: animated)
    }
    
    func updateActiveController(forPage page: Page, animated: Bool = true) {
        scrollView?.setContentOffset(CGPoint(x: CGFloat(page.rawValue) * (scrollView?.bounds.width ?? 0), y: 0), animated: animated)
        
        switch page {
        case .crop:
            cropImageViewController?.setAsset(asset: galleryViewController?.selectedAsset)
            break
        case .share:
            if let croppedImage = cropImageViewController?.croppedImage {
                shareViewController?.viewModel = ShareImageViewModel(with: croppedImage)
            }
            break
        default:
            break
        }
    }
    
    // Upload and share the image
    
    func uploadAndShare() {
        guard let image = shareViewController?.viewModel?.image, let caption = shareViewController?.viewModel?.caption else {
            return
        }
        
        view.window?.showLoadingHUD()
        
        APIClient.sharedInstance.uploadImage(image: image, completion: { [weak self] dictionary in
            guard let filename = dictionary?["filename"] as? String else {
                return
            }
            
            APIClient.sharedInstance.createImage(filename: filename, description: caption, completion: { dictionary in
                self?.view.window?.hideLoadingHUD()
                
                if let message = dictionary?["message"] as? String {
                    self?.showMessage(title: "Image created", content: message)
                }
                self?.presentingViewController?.dismiss(animated: true, completion: nil)
            }, failure: { error in
                self?.view.window?.hideLoadingHUD()
                self?.showError(error: error)
            })
        }) { [weak self] error in
            self?.view.window?.hideLoadingHUD()
            self?.showError(error: error)
        }
        
    }
    
    // MARK: - Photo Auth status
    
    func updateAuthInterface(status: PHAuthorizationStatus) {
        accessDisabledView?.isHidden = (status == .authorized)
    }
    
    // MARK: - Reactive
    
    func observePhotoAuthorizationStatus() {
        authorizationStatus.asObservable().subscribe(onNext: { [weak self] (status) in
            self?.updateAuthInterface(status: status)
        }).disposed(by: disposeBag)
    }
    
    func observePages() {
        page.asObservable().subscribe(onNext: { [weak self] (page) in
            self?.updateButtonItems(forPage: page)
            self?.updateActiveController(forPage: page)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Config
    
    func setupViewControllers() {
        let galleryViewController = instantiateViewController(withIdentifier: GalleryViewController.storyboardIdentifier)
        append(viewController: galleryViewController, to: scrollView)
        self.galleryViewController = galleryViewController as? GalleryViewController
        
        let cropImageViewController = instantiateViewController(withIdentifier: CropImageViewController.storyboardIdentifier)
        append(viewController: cropImageViewController, to: scrollView)
        self.cropImageViewController = cropImageViewController as? CropImageViewController
        
        let shareViewController = instantiateViewController(withIdentifier: ShareImageViewController.storyboardIdentifier)
        append(viewController: shareViewController, to: scrollView)
        self.shareViewController = shareViewController as? ShareImageViewController
        
        viewControllers.append(contentsOf: [galleryViewController, cropImageViewController, shareViewController])
    }
    
    func append(viewController: UIViewController, to scrollView: UIScrollView?) {
        addChildViewController(viewController)
        viewController.view.frame = scrollView?.bounds ?? CGRect.zero
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView?.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = "New Post"
    }

}
