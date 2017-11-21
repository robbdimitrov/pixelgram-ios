//
//  EditProfileViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/31/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class EditProfileViewController: ViewController {
    
    var viewModel: UserViewModel?
    
    @IBOutlet var avatarImageView: UIImageView?
    @IBOutlet var changeAvatarButton: UIButton?
    @IBOutlet var nameInput: InputView?
    @IBOutlet var usernameInput: InputView?
    @IBOutlet var emailInput: InputView?
    @IBOutlet var bioInput: FreeformInputView?
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        setupAvatarControls()
        setupInputElements()
    }
    
    // MARK: - Config
    
    func setupAvatarControls() {
        if let avatarURL = viewModel?.avatarURL {
            avatarImageView?.setImage(with: avatarURL)
        } else {
            avatarImageView?.image = UIImage(named: "avatar_placeholder")
        }
        
        avatarImageView?.layer.cornerRadius = (avatarImageView?.bounds.width ?? 0) / 2.0
        
        changeAvatarButton?.rx.tap.bind { [weak self] in
            self?.openImagePicker()
        }.disposed(by: disposeBag)
    }
    
    func setupInputElements() {
        guard let viewModel = viewModel else {
            return
        }
        
        nameInput?.setup(with: "Name", placeholder: "John Doe", textContent: viewModel.nameText)
        nameInput?.textField?.returnKeyType = .next
        
        usernameInput?.setup(with: "Username", placeholder: "johndoe", textContent: viewModel.usernameText)
        usernameInput?.textField?.returnKeyType = .next
        
        emailInput?.setup(with: "Email", placeholder: "john@example.com", textContent: viewModel.emailText)
        emailInput?.textField?.returnKeyType = .next
        
        bioInput?.setup(with: "Bio", textContent: viewModel.bioText)
        bioInput?.textView?.returnKeyType = .default
    }
    
    // MARK: - Navigation Item
    
    override func leftButtonItems() -> [UIBarButtonItem]? {
        let cancelButton = cancelButtonItem()
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        return [cancelButton]
    }
    
    override func rightButtonItems() -> [UIBarButtonItem]? {
        let doneButton = doneButtonItem()
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.saveUser()
        }).disposed(by: disposeBag)
        
        return [doneButton]
    }
    
    // MARK: - Methods
    
    func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func saveUser() {
        let name = nameInput?.text ?? ""
        let username = usernameInput?.text ?? ""
        let email = emailInput?.text ?? ""
        let bio = bioInput?.text ?? ""
        
        if name.count < 1 {
            showError(error: "Name can't be empty.")
            return
        } else if (username.count < 1) {
            showError(error: "Username can't be empty.")
            return
        } else if (!EmailValidator.isEmailValid(email)) {
            showError(error: "Invalid email address.")
            return
        }
        
        view.window?.showLoadingHUD()
        
        let completion: (String, String, String, String, String?) -> Void = { [weak self] (name, username, email, bio, avatar) in
            let userId = Session.sharedInstance.currentUser?.id ?? ""
            
            APIClient.sharedInstance.editUser(withId: userId, name: name, username: username, email: email, bio: bio, avatar: avatar, completion: { response in
                self?.view.window?.hideLoadingHUD()
                
                self?.showMessage(title: "Success", content: "User updates successfully.")
                self?.presentingViewController?.dismiss(animated: true, completion: nil)
            }, failure: { error in
                self?.view.window?.hideLoadingHUD()
                self?.showError(error: error)
            })
        }
        
        if let image = selectedImage {
            APIClient.sharedInstance.uploadImage(image, completion: { response in
                completion(name, username, email, bio, (response?["filename"] as? String) ?? nil)
            }) { [weak self] error in
                self?.view.window?.hideLoadingHUD()
                
                self?.showError(error: error)
            }
        } else {
            completion(name, username, email, bio, nil)
        }
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = pickedImage
            avatarImageView?.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileViewController: UINavigationControllerDelegate {
    
}
