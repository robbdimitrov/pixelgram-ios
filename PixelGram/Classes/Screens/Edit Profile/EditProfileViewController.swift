//
//  EditProfileViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class EditProfileViewController: CollectionViewController {
    
    var viewModel: EditProfileViewModel?
    
    // MARK: - Config
    
    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = "Edit Profile"
    }
    
    override func leftButtonItems() -> [UIBarButtonItem]? {
        let cancelButton = cancelButtonItem()
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        return [cancelButton]
    }
    
    override func rightButtonItems() -> [UIBarButtonItem]? {
        let doneButton = doneButtonItem()
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.saveUser()
        }).disposed(by: disposeBag)
        
        return [doneButton]
    }
    
    // MARK: - Methods
    
    func saveUser() {
        
    }

}
