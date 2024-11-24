//
//  LoginViewModel.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import Foundation

protocol LoginViewModelProtocol {
    var delegate: LoginViewModelOutputProtocol? {get set}
}

protocol LoginViewModelOutputProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func update()
    func error()
}

final class LoginViewModel {
    weak var delegate: LoginViewModelOutputProtocol?
}

extension LoginViewModel: LoginViewModelProtocol {
    
}
