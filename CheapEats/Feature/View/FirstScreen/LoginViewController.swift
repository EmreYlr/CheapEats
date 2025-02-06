//
//  LoginViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit
import NVActivityIndicatorView

final class LoginViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var emailLayer: UITextField!
    @IBOutlet weak var passwordLayer: UITextField!
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    private var loadIndicator: NVActivityIndicatorView!
    var loginViewModel : LoginViewModelProtocol = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        emailLayer.text = "yeleremre@hotmail.com"
        passwordLayer.text = "123456"
        loginViewModel.delegate = self
        loginButton.layer.cornerRadius = 10
        
    }
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: self.waitView)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = emailLayer.text, let password = passwordLayer.text else { return }
        loginViewModel.loginUser(email: email, password: password)
    }
}
extension LoginViewController: LoginViewModelOutputProtocol {
    func startLoading() {
        waitView.isHidden = false
        waitView.layer.opacity = 0.5
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
        loginButton.isEnabled = false
    }
    
    func stopLoading() {
        waitView.isHidden = true
        waitView.layer.opacity = 0
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
        loginButton.isEnabled = true
    }
    
    func update() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        navigationController?.navigationBar.isHidden = true
        stopLoading()
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    func error() {
        print("error")
        stopLoading()
    }
    
    
}
