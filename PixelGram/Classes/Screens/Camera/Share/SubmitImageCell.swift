//
//  SubmitImageCell.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/2/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class SubmitImageCell: UICollectionViewCell, FullWidth {

    @IBOutlet var imageView: UIImageView?
    @IBOutlet var textView: UITextView?
    @IBOutlet var placeholderLabel: UILabel?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView?.rx.didBeginEditing.bind { [weak self] in
            self?.placeholderLabel?.isHidden = true
        }.disposed(by: disposeBag)
        
        textView?.rx.didEndEditing.bind { [weak self] in
            self?.placeholderLabel?.isHidden = !(self?.textView?.text.isEmpty ?? false)
        }.disposed(by: disposeBag)
    }

}
