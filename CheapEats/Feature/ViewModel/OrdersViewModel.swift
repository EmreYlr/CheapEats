//
//  OrdersDetailView.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation

protocol OrdersViewModelProtocol {
    var delegate: OrdersViewModelOutputProtocol? { get set}
    var orders: [Orders] { get set }
}

protocol OrdersViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class OrdersViewModel {
    weak var delegate: OrdersViewModelOutputProtocol?
    var orders: [Orders] = [Orders(orderNumber: "1234987", company: "Burger King", food: "Whopper", date: "12.12.2024", imageUrl: "testImage", oldAmount: "200", newAmount: "150", orderStatus: .preparing), Orders(orderNumber: "9871234", company: "KFC", food: "Twister", date: "12.12.2024", imageUrl: "testImage3", oldAmount: "100", newAmount: "80", orderStatus: .delivered), Orders(orderNumber: "343123412", company: "McDonald's", food: "Big Mac", date: "12.12.2024", imageUrl: "testImage4", oldAmount: "150", newAmount: "120", orderStatus: .canceled)]
}

extension OrdersViewModel: OrdersViewModelProtocol {}
