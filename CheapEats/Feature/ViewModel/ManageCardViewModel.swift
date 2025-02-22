//
//  ManageCardViewModel.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

protocol ManageCardViewModelProtocol {
    var delegate: ManageCardViewModelOutputProtocol? { get set }
//    func fetchCards()
//    func deleteCard(at index: Int)
//    func addCard(card: Card)
}

protocol ManageCardViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class ManageCardViewModel {
    weak var delegate: ManageCardViewModelOutputProtocol?
}

extension ManageCardViewModel: ManageCardViewModelProtocol { }
