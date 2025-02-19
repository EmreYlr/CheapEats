//
//  OrderDetailViewModel.swift
//  CheapEats
//
//  Created by Emre on 14.12.2024.
//

import Foundation


protocol OrderDetailViewModelProtocol {
    var delegate: OrderDetailViewModelOutputProtocol? { get set}
    var order: UserOrder? { get set }
}

protocol OrderDetailViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class OrderDetailViewModel {
    weak var delegate: OrderDetailViewModelOutputProtocol?
    var order: UserOrder?
}

extension OrderDetailViewModel: OrderDetailViewModelProtocol {}
