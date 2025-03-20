//
//  CartViewModel.swift
//  CheapEats
//
//  Created by Emre on 12.03.2025.
//

import Foundation

protocol CartViewModelProtocol {
    var delegate: CartViewModelOutputProtocol? { get set }
    var cartItems: [ProductDetails] { get set }
}

protocol CartViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class CartViewModel {
    weak var delegate: CartViewModelOutputProtocol?
    var cartItems: [ProductDetails] = []
}

extension CartViewModel: CartViewModelProtocol {}
