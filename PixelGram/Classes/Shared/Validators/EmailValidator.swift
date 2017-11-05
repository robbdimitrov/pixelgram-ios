//
//  EmailValidator.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/5/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import Foundation

class EmailValidator {

    static let emailRegEx = "[^@]+@[^@]+\\.[^@]+"
    
    class func isEmailValid(_ email: String?) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

}
