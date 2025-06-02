//
//  SuccessViewModel.swift
//  CheapEats
//
//  Created by Emre on 2.06.2025.
//

protocol SuccessViewModelProtocol {
    var delegate: SuccessViewModelOutputProtocol? {get set}
}

protocol SuccessViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class SuccessViewModel {
    weak var delegate: SuccessViewModelOutputProtocol?

}

extension SuccessViewModel: SuccessViewModelProtocol {}

