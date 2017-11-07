//
//  SettingsCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/7/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell, FullWidth {

    @IBOutlet var textLabel: UILabel?
    @IBOutlet var accessoryView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAccessoryView()
    }
    
    // MARK: - Config
    
    func setupAccessoryView() {
        accessoryView?.tintColor = UIColor.buttonColor
        
        if let image = accessoryView?.image {
            accessoryView?.image = image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func setup(with viewModel: SettingItemViewModel) {
        textLabel?.text = viewModel.title
        
        accessoryView?.isHidden = !(viewModel.type == .disclosure)
    }

}
