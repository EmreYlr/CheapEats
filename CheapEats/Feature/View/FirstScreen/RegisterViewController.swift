//
//  RegisterViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit
import NVActivityIndicatorView
import JVFloatLabeledTextField

final class RegisterViewController: UIViewController {
    //MARK: -Variables
    
    @IBOutlet weak var nameLabel: JVFloatLabeledTextField!
    @IBOutlet weak var lastnameLabel: JVFloatLabeledTextField!
    @IBOutlet weak var emailLabel: JVFloatLabeledTextField!
    @IBOutlet weak var telNoLabel: JVFloatLabeledTextField!
    @IBOutlet weak var passwordLabel: JVFloatLabeledTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var waitView: UIView!

    private var loadIndicator: NVActivityIndicatorView!
    private var registerViewModel: RegisterViewModelProtocol = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        initScreen()
    }
    
    private func initScreen() {
        registerViewModel.delegate = self
        registerButton.layer.cornerRadius = 10
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
    }
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let name = nameLabel.text, let lastname = lastnameLabel.text, let email = emailLabel.text, let password = passwordLabel.text, let tel = telNoLabel.text else { return }
        registerViewModel.registerUser(email: email,telNo: tel ,password: password, firstName: name, lastName: lastname)
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
