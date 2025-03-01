//
//  ManageCardViewModel.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//
import Foundation

protocol ManageCardViewModelProtocol {
    var delegate: ManageCardViewModelOutputProtocol? { get set }
    var userCreditCards: [UserCreditCards] { get set }
    func fetchUserCreditCards(isRefreshing: Bool)
    func deleteUserCreditCard(at card: String, indexPath: IndexPath)
}

protocol ManageCardViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
    func didDeleteCard(at indexPath: IndexPath)
}

final class ManageCardViewModel {
    weak var delegate: ManageCardViewModelOutputProtocol?
    var userCreditCards: [UserCreditCards] = []
    
    func fetchUserCreditCards(isRefreshing: Bool) {
        userCreditCards.removeAll()
        if isRefreshing {
            delegate?.startLoading()
        }
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
    
    func deleteUserCreditCard(at card: String, indexPath: IndexPath) {
        delegate?.startLoading()
        NetworkManager.shared.deleteUserCreditCard(at: card) { [weak self] result in
            self?.delegate?.stopLoading()
            switch result {
            case .success:
                self?.userCreditCards.remove(at: indexPath.row)
                self?.delegate?.didDeleteCard(at: indexPath)
            case .failure:
                self?.delegate?.error()
            }
        }
    }
}

extension ManageCardViewModel: ManageCardViewModelProtocol { }
