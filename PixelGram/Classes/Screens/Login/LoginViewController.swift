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

    @IBOutlet var emailField: UITextField?
    @IBOutlet var passwordField: UITextField?
    @IBOutlet var loginButton: UIButton?
    @IBOutlet var registerButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Log In"
        
        setupLoginForm();
        setupRegisterButton();
    }
    
    // MARK: - Reactive
    
    func setupLoginForm() {
        guard let emailField = emailField, let passwordField = passwordField,
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
            self?.login(with: self?.emailField?.text ?? "",
                        password: self?.passwordField?.text ?? "")
        }.disposed(by: disposeBag)
    }
    
    func setupRegisterButton() {
        registerButton?.rx.tap.bind { [weak self] in
            self?.openRegistration()
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Login
    
    func login(with email: String, password: String) {
        
    }
    
    // MARK: - Navigation
    
    func openRegistration() {
        let viewController = instantiateViewController(withIdentifier: SignupViewController.storyboardIdentifier)
        navigationController?.pushViewController(viewController, animated: true)
    }

}
