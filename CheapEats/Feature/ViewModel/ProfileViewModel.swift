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
}

protocol ProfileViewModelOutputProtocol: AnyObject{
    func update()
    func error()
}


final class ProfileViewModel {
    weak var delegate: ProfileViewModelOutputProtocol?
    var user: Users?
    init() {
        self.user = UserManager.shared.user
    }
}
extension ProfileViewModel: ProfileViewModelProtocol {}
