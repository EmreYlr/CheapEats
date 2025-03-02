//
//  EditProfileViewController.swift
//  CheapEats
//
//  Created by Emre on 2.03.2025.
//

import UIKit

final class EditProfileViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    var editProfileViewModel: EditProfileViewModelProtocol = EditProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initScreen()
        setupTextFieldObservers()
        print("EditProfileViewController")
    }
    
    func initScreen() {
        editProfileViewModel.delegate = self
        editView.layer.cornerRadius = 10
        editView.layer.masksToBounds = true
        applyButton.layer.cornerRadius = 5
        setShadow(with: editView.layer, shadowOffset: true)
        updateButtonState()
    }
    
    func initData() {
        if let user = editProfileViewModel.user {
            nameTextField.text = user.firstName
            surnameTextField.text = user.lastName
            phoneNoTextField.text = user.phoneNumber
            emailTextField.text = user.email
        }
    }
    
    private func setupTextFieldObservers() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNoTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateButtonState()
    }
    
    private func updateButtonState() {
        let hasChanges = editProfileViewModel.checkForChanges(
            name: nameTextField.text,
            surname: surnameTextField.text,
            email: emailTextField.text,
            phone: phoneNoTextField.text
        )
        applyButton.isEnabled = hasChanges
        applyButton.alpha = hasChanges ? 1.0 : 0.5
    }
    
    @IBAction func applyButtonClicked(_ sender: UIButton) {
        editProfileViewModel.updateUserInfo(
            name: nameTextField.text,
            surname: surnameTextField.text,
            email: emailTextField.text,
            phone: phoneNoTextField.text
        )
    }
}

extension EditProfileViewController: EditProfileViewModelOutputProtocol {
    func update() {
        print("Update")
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("UserProfileUpdated"), object: nil)
        
    }
    
    func error() {
        print("Error")
    }
    
    func updateButtonState(isEnabled: Bool) {
        applyButton.isEnabled = isEnabled
        applyButton.alpha = isEnabled ? 1.0 : 0.5
    }
}
