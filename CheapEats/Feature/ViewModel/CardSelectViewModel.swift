//
//  CardSelectedViewModel.swift
//  CheapEats
//
//  Created by Emre on 23.03.2025.
//

protocol CardSelectViewModelProtocol {
    var delegate: CardSelectViewModelOutputProtocol? { get set }
    var userCreditCards: [UserCreditCards] { get }
    var selectedCard: UserCreditCards? { get set }
    func getSelectedCard() -> UserCreditCards
    func getCreditCards()
}

protocol CardSelectViewModelDelegate: AnyObject {
    func didApplySelection(selectedOption: UserCreditCards?)
}

protocol CardSelectViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class CardSelectViewModel {
    weak var delegate: CardSelectViewModelOutputProtocol?
    var selectedCard: UserCreditCards?
    var userCreditCards: [UserCreditCards] = []
    
    func getSelectedCard() -> UserCreditCards {
        guard let selectedCard = selectedCard else { return UserCreditCards(cardName: "", cardOwnerName: "", cardNo: "", cardMonth: 0, cardYear: 0, CVV: 0, cardType: .visa) }
        return selectedCard
    }
    
    func getCreditCards() {
        userCreditCards.removeAll()
        delegate?.startLoading()

        NetworkManager.shared.fetchUserCreditCards { [weak self] result in
            self?.delegate?.stopLoading()
            switch result {
            case .success(let userCreditCards):
                self?.userCreditCards = userCreditCards
                self?.delegate?.update()
            case .failure:
                self?.delegate?.error()
            }
        }
    }
}

extension CardSelectViewModel: CardSelectViewModelProtocol {}
