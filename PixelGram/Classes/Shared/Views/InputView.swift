//
//  InputView.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/6/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class InputView: UIView {

    var textLabel: UILabel?
    var textField: UITextField?
    var separator: UIView?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Setters
    
    var isSecureField = false {
        didSet {
            textField?.rightView = isSecureField ? showHideButton() : nil
            textField?.rightViewMode = .always
            textField?.isSecureTextEntry = isSecureField
        }
    }
    
    func setup(with label: String?, placeholder: String?, isSecureField: Bool = false, textContent: String? = "") {
        textLabel?.text = label
        textField?.placeholder = placeholder
        textField?.text = textContent
        self.isSecureField = isSecureField
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        textLabel = UILabel()
        textField = UITextField()
        separator = UIView()
        
        if let textLabel = textLabel, let textField = textField, let separator = separator {
            addSubview(textLabel)
            addSubview(textField)
            addSubview(separator)
        }
        
        setupTextField()
        setupTextLabel()
        setupSeparator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = bounds
        
        let labelWidth = frame.width * 0.4
        let textFieldWidth = frame.width * 0.6
        
        textLabel?.frame = CGRect(x: 0, y: 0,
                                 width: labelWidth, height: frame.height - 1)
        textField?.frame = CGRect(x: (textLabel?.frame.maxX ?? 0) + 1, y: 0,
                                 width: textFieldWidth, height: frame.height - 1)
        separator?.frame = CGRect(x: 0, y: frame.maxY - 1, width: frame.width, height: 1)
        
        if let button = textField?.rightView as? UIButton {
            let padding: CGFloat = 5.0
            
            let buttonSize = button.sizeThatFits(CGSize(width: (textLabel?.frame.width ?? 0) * 0.4,
                                                        height: (textLabel?.frame.height ?? 0)))
            button.frame = CGRect(x: 0, y: 0, width: buttonSize.width + 2 * padding,
                                  height: buttonSize.height + 2 * padding)
        }
    }
    
    // MARK: - Components
    
    func showHideButton() -> UIButton {
        let button = RoundedButton(type: .custom)
        
        button.setTitle("SHOW", for: .normal)
        button.setTitle("HIDE", for: .selected)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        button.setTitleColor(UIColor.buttonSelectedColor, for: .normal)
        button.setTitleColor(UIColor.buttonSelectedColor, for: .selected)
        
        button.rx.tap.bind { [weak self, weak button] in
            let value = self?.textField?.isSecureTextEntry ?? false
            
            self?.textField?.isSecureTextEntry = !value
            button?.isSelected = !value
            
        }.disposed(by: disposeBag)
        
        return button
    }
    
    // MARK: - Config
    
    func setupTextLabel() {
        textLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
    }
    
    func setupTextField() {
        textField?.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
    }
    
    func setupSeparator() {
        separator?.backgroundColor = UIColor.buttonColor
    }
    
}
