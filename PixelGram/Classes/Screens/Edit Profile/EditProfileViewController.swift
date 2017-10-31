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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Config
    
    override func setupNavigationItem() {
        super.setupNavigationItem()
        
        title = "Edit Profile"
        
//        let doneButton = doneButtonItem()
//        let cancelButton = cancelButtonItem()
//
//        doneButton.rx.tap
    }
    
    

}
