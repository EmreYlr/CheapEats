//
//  DeliveryViewModel.swift
//  CheapEats
//
//  Created by Emre on 22.03.2025.
//

protocol DeliveryViewModelProtocol {
    var delegate: DeliveryViewModelOutputProtocol? { get set }
    var cartItems: [ProductDetails] { get set }
    var totalAmount: Double { get set }
    var oldTotalAmount: Double { get set }
}

protocol DeliveryViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class DeliveryViewModel {
    weak var delegate: DeliveryViewModelOutputProtocol?
    var cartItems: [ProductDetails] = []
    var totalAmount: Double = 0.0
    var oldTotalAmount: Double = 0.0
}

extension DeliveryViewModel: DeliveryViewModelProtocol {}
