//
//  FreeformInputView.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/7/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

class FreeformInputView: UIView, Input {

    var textLabel: UILabel?
    var textView: UITextView?
    
    var text: String? {
        return textView?.text
    }
    
    // MARK: - Config
    
    // Note: placeholder and isSecureField aren't used in this class
    func setup(with label: String?, placeholder: String? = "", isSecureField: Bool = false, textContent: String? = "") {
        textLabel?.text = label
        textView?.text = textContent ?? ""
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        textLabel = UILabel()
        textView = UITextView()
        
        if let textLabel = textLabel, let textView = textView {
            addSubview(textLabel)
            addSubview(textView)
        }
        
        setupTextLabel()
        setupTextView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = bounds
        
        let labelWidth = frame.width * 0.4
        let textFieldWidth = frame.width * 0.6
        
        textLabel?.frame = CGRect(x: 0, y: 0,
                                  width: labelWidth, height: min(frame.height, 50.0))
        textView?.frame = CGRect(x: (textLabel?.frame.maxX ?? 0) + 1, y: 0,
                                  width: textFieldWidth, height: frame.height)
    }
    
    // MARK: - First responder
    
    override var isFirstResponder: Bool {
        return textView?.isFirstResponder ?? false
    }
    
    func becomeFirstResponder() {
        textView?.becomeFirstResponder
    }
    
    func resignFirstResponder() {
        textView?.resignFirstResponder()
    }
    
    // MARK: - Config
    
    func setupTextLabel() {
        textLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
    }
    
    func setupTextView() {
        textView?.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
    }
    
}
