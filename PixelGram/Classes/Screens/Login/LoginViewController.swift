//
//  LoginViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/27/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class LoginViewController: ViewController {

    @IBOutlet var emailInput: InputView?
    @IBOutlet var passwordInput: InputView?
    @IBOutlet var loginButton: UIButton?
    @IBOutlet var registerButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Log In"
        
        setupInputElements()
        setupLoginForm()
        setupRegisterButton()
    }
    
    // MARK: - Config
    
    func setupInputElements() {
        emailInput?.setup(with: "Email", placeholder: "john@example.com")
        emailInput?.textField?.returnKeyType = .next
        
        passwordInput?.setup(with: "Password", placeholder: nil, isSecureField: true)
        passwordInput?.textField?.returnKeyType = .done
    }
    
    // MARK: - Reactive
    
    func setupLoginForm() {
        guard let emailField = emailInput?.textField, let passwordField = passwordInput?.textField,
            let loginButton = loginButton else {
            return
        }
        
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
        
        let enableButton =  Observable.combineLatest(emailValidation, passwordValidation) { (email, password) in
            return email && password
        }
        
        enableButton
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.bind { [weak self] in
            self?.login(with: self?.emailInput?.textField?.text ?? "",
                        password: self?.passwordInput?.textField?.text ?? "")
        }.disposed(by: disposeBag)
    }
    
    func setupRegisterButton() {
        registerButton?.rx.tap.bind { [weak self] in
            self?.openRegistration()
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Login
    
    func login(with email: String, password: String) {
        APIClient.sharedInstance.login(with: email, password: password, completion: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }) { [weak self] error in
            self?.showError(error: error)
        }
    }
    
    // MARK: - Navigation
    
    func openRegistration() {
        let viewController = instantiateViewController(withIdentifier: SignupViewController.storyboardIdentifier)
        navigationController?.pushViewController(viewController, animated: true)
    }

}
