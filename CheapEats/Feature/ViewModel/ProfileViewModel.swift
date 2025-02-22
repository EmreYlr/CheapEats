//
//  ProfileViewModelProtocol.swift
//  CheapEats
//
//  Created by CANSU on 3.12.2024.
//

import Foundation
protocol ProfileViewModelProtocol{
    var delegate: ProfileViewModelOutputProtocol? { get set}
    var user: Users? { get set }
    func signOut()
}

protocol ProfileViewModelOutputProtocol: AnyObject{
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class ProfileViewModel {
    weak var delegate: ProfileViewModelOutputProtocol?
    var user: Users?
    
    init() {
        self.user = UserManager.shared.user
    }
    
    func signOut() {
        self.delegate?.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NetworkManager.shared.signOutUser { [weak self] result in
                self?.delegate?.stopLoading()
                switch result {
                case .success:
                    UserManager.shared.signOut()
                    self?.delegate?.update()
                case .failure:
                    self?.delegate?.error()
                }
            }
        }
    }
}
extension ProfileViewModel: ProfileViewModelProtocol {}
