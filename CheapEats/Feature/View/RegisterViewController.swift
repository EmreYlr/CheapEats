//
//  RegisterViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit

final class RegisterViewController: UIViewController {
    //MARK: -Variables
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var lastnameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    private var registerViewModel: RegisterViewModelProtocol = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewModel.delegate = self
        registerButton.layer.cornerRadius = 10
    }
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let name = nameLabel.text, let lastname = lastnameLabel.text, let email = emailLabel.text, let password = passwordLabel.text else { return }
        registerViewModel.registerUser(email: email, password: password, firstName: name, lastName: lastname)
    }
}

extension RegisterViewController: RegisterViewModelOutputProtocol {
    func update() {
        print("User registered successfully!")
    }
    
    func error() {
        print("Error registering user!")
    }
    
    func startLoading() {
        print("Loading started")
    }
    
    func stopLoading() {
        print("Loading stopped")
    }
    
}
