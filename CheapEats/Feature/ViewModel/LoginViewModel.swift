//
//  LoginViewModel.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import Foundation

protocol LoginViewModelProtocol {
    var delegate: LoginViewModelOutputProtocol? {get set}
    func loginUser(email: String, password: String)
}

protocol LoginViewModelOutputProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func update()
    func error()
}

final class LoginViewModel {
    weak var delegate: LoginViewModelOutputProtocol?
    
    func loginUser(email: String, password: String) {
        self.delegate?.startLoading()
        NetworkManager.shared.loginUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.update()
            case .failure:
                self.delegate?.error()
            }
            self.delegate?.stopLoading()
        }
    }
}

extension LoginViewModel: LoginViewModelProtocol {
    
}
