//
//  RoundedButton.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RoundedButton: ObservableButton {

    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureBorder()
        
        tintColor = UIColor.buttonSelectedColor
        
        isHighlightedVariable.asObservable().subscribe(onNext: { [weak self] (highlighted) in
            if highlighted {
                self?.layer.borderColor = UIColor.buttonSelectedColor.cgColor
            } else {
                self?.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
            }
        }).disposed(by: disposeBag)
    }
    
    func configureBorder() {
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.contentsScale = UIScreen.main.scale
    }

}
