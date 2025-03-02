//
//  EditProfileViewModel.swift
//  CheapEats
//
//  Created by Emre on 2.03.2025.
//

protocol EditProfileViewModelProtocol {
    var delegate: EditProfileViewModelOutputProtocol? { get set }
    var user: Users? { get set }
    func checkForChanges(name: String?, surname: String?, email: String?, phone: String?) -> Bool
    func updateUserInfo(name: String?, surname: String?, email: String?, phone: String?)
}

protocol EditProfileViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func updateButtonState(isEnabled: Bool)
}

final class EditProfileViewModel {
    weak var delegate: EditProfileViewModelOutputProtocol?
    var user: Users?
    
    private var originalName: String = ""
    private var originalSurname: String = ""
    private var originalEmail: String = ""
    private var originalPhone: String = ""
    
    init() {
        user = UserManager.shared.user
        
        if let user = user {
            originalName = user.firstName
            originalSurname = user.lastName
            originalEmail = user.email
            originalPhone = user.phoneNumber
        }
    }
    
    func checkForChanges(name: String?, surname: String?, email: String?, phone: String?) -> Bool {
        let currentName = name ?? ""
        let currentSurname = surname ?? ""
        let currentEmail = email ?? ""
        let currentPhone = phone ?? ""
        
        let hasChanges = currentName != originalName ||
                        currentSurname != originalSurname ||
                        currentEmail != originalEmail ||
                        currentPhone != originalPhone
        
        return hasChanges
    }
    
    func updateUserInfo(name: String?, surname: String?, email: String?, phone: String?) {
        let user = Users(firstName: name ?? "", lastName: surname ?? "", email: email ?? "", phoneNumber: phone ?? "")
        NetworkManager.shared.updateUserInfo(user: user) { result in
            switch result {
            case .success:
                self.delegate?.update()
            case .failure(let error):
                print(error)
                self.delegate?.error()
            }
        }
        
    }
}

extension EditProfileViewModel: EditProfileViewModelProtocol {}
