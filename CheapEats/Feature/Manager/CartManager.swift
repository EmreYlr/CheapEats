//
//  CartManager.swift
//  CheapEats
//
//  Created by Emre on 10.03.2025.
//

import Foundation

final class CartManager {
    static let shared = CartManager()
    
    private init() {}
    
    var selectedProduct: ProductDetails?
    
    func addProduct(_ product: ProductDetails) {
        selectedProduct = product
    }
    
    func removeProduct() {
        selectedProduct = nil
    }
    
    func getProduct() -> ProductDetails? {
        return selectedProduct
    }
}
