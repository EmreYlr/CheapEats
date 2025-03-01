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
    func didAddCard(_ card: UserCreditCards)
    func error()
}

final class AddCardViewModel {
    weak var delegate: AddCardViewModelOutputProtocol?
    
    func addCard(userCreditCart: UserCreditCards) {
        var card = userCreditCart
        NetworkManager.shared.addUserCreditCard(card: userCreditCart) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let result):
                card.cardId = result
                self.delegate?.didAddCard(card)
            case .failure:
                self.delegate?.error()
            }
        }
    }
}

extension AddCardViewModel: AddCardViewModelProtocol { }
