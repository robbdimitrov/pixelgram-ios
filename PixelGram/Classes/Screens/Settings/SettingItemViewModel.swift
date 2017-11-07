//
//  SettingItemViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/7/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

struct SettingItemViewModel {

    var title: String
    var type: SettingsViewModel.SettingsCellType
    var closure: (() -> Void)?
    
}
