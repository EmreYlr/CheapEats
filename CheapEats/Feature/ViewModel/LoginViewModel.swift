//
//  LoginViewModel.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import Foundation
import FirebaseAuth

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
    var userUID: String?
    func loginUser(email: String, password: String) {
        self.delegate?.startLoading()
        NetworkManager.shared.loginUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let userUID = getCurrentUser()?.uid else{
                    self.delegate?.error()
                    self.delegate?.stopLoading()
                    return
                }
                self.getUserInfo(uid: userUID)
            case .failure:
                self.delegate?.error()
            }
            self.delegate?.stopLoading()
        }
    }
    
    private func getCurrentUser() -> User? {
        if let user = Auth.auth().currentUser {
            return user
        }
        return nil
    }
    
    private func getUserInfo(uid: String) {
        NetworkManager.shared.getUserInfo(uid: uid) { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                UserManager.shared.user = user
                self.delegate?.update()
            } else {
                self.delegate?.error()
            }
        }
    }
}

extension LoginViewModel: LoginViewModelProtocol {
    
}
