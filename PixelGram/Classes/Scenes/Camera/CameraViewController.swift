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

class CameraViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photo"
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let closeButton = UIBarButtonItem(title: "Close",
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = closeButton
    }

}
