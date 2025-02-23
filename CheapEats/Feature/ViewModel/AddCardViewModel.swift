//
//  AddCardViewModel.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

protocol AddCardViewModelProtocol {
    var delegate: AddCardViewModelOutputProtocol? { get set }
}

protocol AddCardViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class AddCardViewModel {
    weak var delegate: AddCardViewModelOutputProtocol?
}

extension AddCardViewModel: AddCardViewModelProtocol { }
