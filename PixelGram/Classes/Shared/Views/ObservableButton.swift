//
//  ObservableButton.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift

class ObservableButton: UIButton {

    var isHighlightedVariable = Variable(false)
    
    override var isHighlighted: Bool {
        didSet {
            isHighlightedVariable.value = isHighlighted
        }
    }

}
