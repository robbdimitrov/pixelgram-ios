//
//  Input.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/7/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

protocol Input: class {
    
    var text: String? { get }
    
    var isFirstResponder: Bool { get }
    
    func setup(with label: String?, placeholder: String?, isSecureField: Bool, textContent: String?) -> Void
    
    func becomeFirstResponder()
    
    func resignFirstResponder()
    
}
