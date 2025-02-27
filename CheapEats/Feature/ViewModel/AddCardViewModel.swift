//
//  AddCardViewModel.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

protocol AddCardViewModelProtocol {
    var delegate: AddCardViewModelOutputProtocol? { get set }
    func addCard(userCreditCart: UserCreditCards)
}

protocol AddCardViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class AddCardViewModel {
    weak var delegate: AddCardViewModelOutputProtocol?
    
    func addCard(userCreditCart: UserCreditCards) {
        NetworkManager.shared.addUserCreditCard(card: userCreditCart) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.update()
            case .failure:
                self.delegate?.error()
            }
        }
    }
}

extension AddCardViewModel: AddCardViewModelProtocol { }
