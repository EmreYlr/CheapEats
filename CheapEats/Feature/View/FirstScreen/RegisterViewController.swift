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
    
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    private var registerViewModel: RegisterViewModelProtocol = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewModel.delegate = self
        registerButton.layer.cornerRadius = 10
        loadIndicator.color = UIColor(named: "ButtonColor")
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let name = nameLabel.text, let lastname = lastnameLabel.text, let email = emailLabel.text, let password = passwordLabel.text else { return }
        registerViewModel.registerUser(email: email, password: password, firstName: name, lastName: lastname)
    }
}

extension RegisterViewController: RegisterViewModelOutputProtocol {
    func update() {
        //TODO: -ALERT YAPILACAK
        stopLoading()
        navigationController?.popViewController(animated: true)
        print("User registered successfully!")
    }
    
    func error() {
        print("Error registering user!")
        stopLoading()
    }
    
    func startLoading() {
        waitView.isHidden = false
        waitView.layer.opacity = 0.5
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
        registerButton.isEnabled = false
    }
    
    func stopLoading() {
        waitView.isHidden = true
        waitView.layer.opacity = 0
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
        registerButton.isEnabled = true
    }
    
}
