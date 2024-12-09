//
//  OrdersDetailView.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation

protocol OrdersDetailViewModelProtocol {
    var delegate: OrdersDetailViewModelOutputProtocol? { get set}
}

protocol OrdersDetailViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class OrdersDetailViewModel {
    weak var delegate: OrdersDetailViewModelOutputProtocol?
}

extension OrdersDetailViewModel: OrdersDetailViewModelProtocol {}
