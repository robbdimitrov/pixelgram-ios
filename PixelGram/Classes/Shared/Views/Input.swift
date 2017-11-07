//
//  Input.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/7/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

protocol Input {
    
    func setup(with label: String?, placeholder: String?, isSecureField: Bool, textContent: String?) -> Void
    
    var text: String? { get }
    
}
