//
//  LoginViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit

final class LoginViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var emailLayer: UITextField!
    @IBOutlet weak var passwordLayer: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    var loginViewModel : LoginViewModelProtocol = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.delegate = self
        loginButton.layer.cornerRadius = 10
        
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = emailLayer.text, let password = passwordLayer.text else { return }
        loginViewModel.loginUser(email: email, password: password)
    }
}
extension LoginViewController: LoginViewModelOutputProtocol {
    func startLoading() {
        print("startLoading")
    }
    
    func stopLoading() {
        print("stopLoading")
    }
    
    func update() {
        print("update")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func error() {
        print("error")
    }
    
    
}
