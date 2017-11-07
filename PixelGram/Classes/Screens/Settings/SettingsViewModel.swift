//
//  SettingsViewModel.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//


class SettingsViewModel {
    
    enum SettingsCellType: Int {
        case disclosure
        case button
    }
    
    var items = [SettingItemViewModel]()
    
    var changePasswordClosure: (() -> Void)?
    var likedImagesClosure: (() -> Void)?
    var logoutClosure: (() -> Void)?
    
    var numberOfItems: Int {
        return items.count
    }
    
    func settingViewModel(forIndex index: Int) -> SettingItemViewModel {
        return items[index]
    }
    
    func setupItems() {
        let item1 = SettingItemViewModel(title: "Change password",
                                         type: .disclosure,
                                         closure: changePasswordClosure)
        
        let item2 = SettingItemViewModel(title: "Posts you've liked",
                                         type: .disclosure,
                                         closure: likedImagesClosure)
        
        let item3 = SettingItemViewModel(title: "Logout",
                                         type: .button,
                                         closure: logoutClosure)
        
        items.append(contentsOf: [item1, item2, item3])
    }
    
    func performClosure(for index: Int) {
        let item = items[index]
        item.closure?()
    }
    
}
