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

    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = "Photo"
    }
    
    override func leftButtonItems() -> [UIBarButtonItem]? {
        let closeButton = closeButtonItem()
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        return [closeButton]
    }

}
