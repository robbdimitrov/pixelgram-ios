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
    
    var viewModel = EditProfileViewModel()
    
    @IBOutlet var avatarImageView: UIImageView?
    @IBOutlet var changeAvatarButton: UIButton?
    @IBOutlet var nameInput: InputView?
    @IBOutlet var usernameInput: InputView?
    @IBOutlet var emailInput: InputView?
    @IBOutlet var bioInput: FreeformInputView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        setupAvatarControls()
        setupInputElements()
    }
    
    // MARK: - Config
    
    func setupAvatarControls() {
        if let avatarURL = viewModel.avatarURL {
            avatarImageView?.setImage(with: avatarURL)
        } else {
            // Use placeholder image
        }
        
        avatarImageView?.layer.cornerRadius = (avatarImageView?.bounds.width ?? 0) / 2.0
        
        changeAvatarButton?.rx.tap.bind { [weak self] in
            self?.openImagePicker()
        }.disposed(by: disposeBag)
    }
    
    func setupInputElements() {
        nameInput?.setup(with: "Name", placeholder: "John Doe", textContent: viewModel.nameText)
        usernameInput?.setup(with: "Username", placeholder: "johndoe", textContent: viewModel.usernameText)
        emailInput?.setup(with: "Email", placeholder: "john@example.com", textContent: viewModel.emailText)
        bioInput?.setup(with: "Bio", textContent: viewModel.bioText)
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
        viewModel.saveUser()
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
