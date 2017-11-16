//
//  ViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
    }
    
    // MARK: - Config
    
    func setupNavigationItem() {
        navigationItem.leftBarButtonItems = leftButtonItems()
        navigationItem.rightBarButtonItems = rightButtonItems()
    }
    
    func leftButtonItems() -> [UIBarButtonItem]? {
        // Implemented by subclasses
        return nil
    }
    
    func rightButtonItems() -> [UIBarButtonItem]? {
        // Implemented by subclasses
        return nil
    }
    
    func setupTitleView(with image: UIImage) {
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
    
    func setupTitleView(with title: String, font: UIFont = UIFont.systemFont(ofSize: 17.0)) {
        let label = UILabel()
        label.font = font
        label.text = title
        
        navigationItem.titleView = label
    }
    
    // MARK: - State
    
    func showMessage(title: String, content: String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showError(error: String) {
        showMessage(title: "Error", content: error)
    }
    
    // MARK: - Components
    
    func buttonItem(with title: String) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .plain,
                               target: nil, action: nil)
    }
    
    func cancelButtonItem() -> UIBarButtonItem {
        return buttonItem(with: "Cancel")
    }
    
    func doneButtonItem() -> UIBarButtonItem {
        return buttonItem(with: "Done")
    }
    
    func closeButtonItem() -> UIBarButtonItem {
        return buttonItem(with: "Close")
    }
    
    // MARK: - Storyboard
    
    func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
        guard let storyboard = storyboard else {
            print("Storyboard is nil")
            return UIViewController()
        }
        
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

}
