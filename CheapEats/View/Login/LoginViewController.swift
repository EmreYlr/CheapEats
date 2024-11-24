//
//  LoginViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit

final class LoginViewController: UIViewController {
    //MARK: -Variables
    var loginViewModel : LoginViewModelProtocol = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.delegate = self
        
    }
}
extension LoginViewController: LoginViewModelOutputProtocol {
    func startLoading() {
        <#code#>
    }
    
    func stopLoading() {
        <#code#>
    }
    
    func update() {
        <#code#>
    }
    
    func error() {
        <#code#>
    }
    
    
}
