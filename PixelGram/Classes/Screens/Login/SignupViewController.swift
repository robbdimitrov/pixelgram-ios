//
//  SignupViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 11/5/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SignupViewController: ViewController {

    @IBOutlet var nameInput: InputView?
    @IBOutlet var usernameInput: InputView?
    @IBOutlet var emailInput: InputView?
    @IBOutlet var passwordInput: InputView?
    @IBOutlet var registerButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Register"
        
        setupInputElements()
        setupLoginForm()
    }
    
    // MARK: - Config
    
    func setupInputElements() {
        nameInput?.setup(with: "Name", placeholder: "John Doe")
        usernameInput?.setup(with: "Username", placeholder: "johndoe")
        emailInput?.setup(with: "Email", placeholder: "john@example.com")
        passwordInput?.setup(with: "Password", placeholder: nil, isSecureField: true)
    }
    
    // MARK: - Reactive
    
    func setupLoginForm() {
        guard let nameField = nameInput?.textField, let usernameField = usernameInput?.textField,
            let emailField = emailInput?.textField, let passwordField = passwordInput?.textField,
            let registerButton = registerButton else {
                
                return
        }
        
        let nameValidation = nameField
            .rx.text
            .map({
                !($0?.isEmpty ?? false)
            })
            .share(replay: 1)
        
        let usernameValidation = usernameField
            .rx.text
            .map({
                !($0?.isEmpty ?? false)
            })
            .share(replay: 1)
        
        let emailValidation = emailField
            .rx.text
            .map({
                EmailValidator.isEmailValid($0)
            })
            .share(replay: 1)
        
        let passwordValidation = passwordField
            .rx.text
            .map({
                !($0?.isEmpty ?? false)
            })
            .share(replay: 1)
        
        let enableButton =  Observable.combineLatest(nameValidation, usernameValidation, emailValidation, passwordValidation) {
            (name, username, email, password) in
            
            return name && username && email && password
        }
        
        enableButton
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap.bind { [weak self] in
            self?.register(with: self?.nameInput?.textField?.text ?? "",
                           username: self?.usernameInput?.textField?.text ?? "",
                           email: self?.emailInput?.textField?.text ?? "",
                           password: self?.passwordInput?.textField?.text ?? "")
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Login
    
    func register(with name: String, username: String, email: String, password: String) {
        
    }

}
