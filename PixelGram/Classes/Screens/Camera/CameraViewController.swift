//
//  CameraViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/28/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

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
    
    var page = Variable(Page.gallery)
    var viewControllers = [UIViewController]()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        observePages()
        updateButtonItems(forPage: page.value, animated: false)
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
                print("share image here")
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: rightButton.disposeBag)
        }
        
        navigationItem.setLeftBarButton(leftButton, animated: animated)
        navigationItem.setRightBarButton(rightButton, animated: animated)
        
    }
    
    func updateActiveController(forPage page: Page, animated: Bool = true) {
        scrollView?.setContentOffset(CGPoint(x: CGFloat(page.rawValue) * (scrollView?.bounds.width ?? 0), y: 0), animated: animated)
        
        switch page {
        case .crop:
            cropImageViewController?.asset = galleryViewController?.selectedAsset
            break
        case .share:
            
            break
        default:
            break
        }
    }
    
    // MARK: - Reactive
    
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
