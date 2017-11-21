//
//  ChangePasswordViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/7/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ChangePasswordViewController: ViewController {

    @IBOutlet var oldPassword: InputView?
    @IBOutlet var newPassword: InputView?
    @IBOutlet var changeButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Change Password"
        
        setupInputElements()
        setupForm()
    }
    
    // MARK: - Config
    
    func setupInputElements() {
        oldPassword?.setup(with: "Old Password", placeholder: nil, isSecureField: true)
        oldPassword?.textField?.returnKeyType = .next
        
        newPassword?.setup(with: "New Password", placeholder: nil, isSecureField: true)
        newPassword?.textField?.returnKeyType = .done
    }
    
    // MARK: - Reactive
    
    func setupForm() {
        guard let oldPasswordField = oldPassword?.textField, let newPasswordField = newPassword?.textField,
            let changeButton = changeButton else {
                return
        }
        
        let oldPasswordValidation = oldPasswordField
            .rx.text
            .map({
                !($0?.isEmpty ?? false)
            })
            .share(replay: 1)
        
        let newPasswordValidation = newPasswordField
            .rx.text
            .map({
                !($0?.isEmpty ?? false)
            })
            .share(replay: 1)
        
        let enableButton =  Observable.combineLatest(oldPasswordValidation, newPasswordValidation) { (oldPassword, newPassword) in
            return oldPassword && newPassword
        }
        
        enableButton
            .bind(to: changeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        changeButton.rx.tap.bind { [weak self] in
            self?.changePassword(with: self?.oldPassword?.textField?.text ?? "",
                        newPassword: self?.newPassword?.textField?.text ?? "")
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Login
    
    func changePassword(with oldPassword: String, newPassword: String) {
        let id = Session.shared.currentUser?.id ?? ""
        
        APIClient.shared.changePassword(forUserId: id, oldPassword: oldPassword, password: newPassword, completion: { [weak self] in
            APIClient.shared.logout(completion: {
                self?.showMessage(title: "Password changed successfully", content: "Login with your new password.")
                self?.navigationController?.popToRootViewController(animated: true)
                self?.tabViewController?.handleTabSelection(withSelected: TabViewController.Tab.feed.rawValue)
            })
        }) { [weak self] error in
            self?.showError(error: error)
        }
    }

}
