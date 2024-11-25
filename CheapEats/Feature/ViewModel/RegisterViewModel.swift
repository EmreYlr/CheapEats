//
//  RegisterViewModel.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import Foundation

protocol RegisterViewModelProtocol {
    var delegate: RegisterViewModelOutputProtocol? {get set}
    func registerUser(email: String, password: String, firstName: String, lastName: String)
}

protocol RegisterViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class RegisterViewModel {
    weak var delegate: RegisterViewModelOutputProtocol?
    
    func registerUser(email: String, password: String, firstName: String, lastName: String) {
        self.delegate?.startLoading()
        NetworkManager.shared.registerUser(email: email, password: password, firstName: firstName, lastName: lastName) { [weak self] result in
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

extension RegisterViewModel: RegisterViewModelProtocol { }
