//
//  OrdersDetailView.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation

protocol OrdersViewModelProtocol {
    var delegate: OrdersViewModelOutputProtocol? { get set}
}

protocol OrdersViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class OrdersViewModel {
    weak var delegate: OrdersViewModelOutputProtocol?
}

extension OrdersViewModel: OrdersViewModelProtocol {}
