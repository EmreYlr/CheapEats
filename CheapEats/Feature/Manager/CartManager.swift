//
//  CartManager.swift
//  CheapEats
//
//  Created by Emre on 10.03.2025.
//

import Foundation

final class CartManager {
    static let shared = CartManager()
    private let cartKey = "user_cart"

    private init() {
        selectedProduct = CartManager.loadCartFromUserDefaults()
    }
    
    var selectedProduct: [ProductDetails] {
        didSet {
            CartManager.saveCartToUserDefaults(selectedProduct)
        }
    }
    
    private static func saveCartToUserDefaults(_ cart: [ProductDetails]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cart) {
            UserDefaults.standard.set(encoded, forKey: "user_cart")
        }
    }

    private static func loadCartFromUserDefaults() -> [ProductDetails] {
        if let data = UserDefaults.standard.data(forKey: "user_cart") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ProductDetails].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    func isProductAlreadySelected(_ product: ProductDetails) -> Bool {
        return selectedProduct.contains(where: { $0.product.productId == product.product.productId })
    }

    func isProductInStock(_ product: ProductDetails) -> Bool {
        if let index = selectedProduct.firstIndex(where: { $0.product.productId == product.product.productId }) {
            return selectedProduct[index].product.selectedCount < selectedProduct[index].product.quantity
        }
        return false
    }

    
    func addProduct(_ product: ProductDetails) -> AddProductResult {
        if selectedProduct.isEmpty {
            if product.product.quantity > 0 {
                var updatedProduct = product.product
                updatedProduct.selectedCount = 1
                let newProductDetails = ProductDetails(product: updatedProduct, restaurant: product.restaurant)
                selectedProduct.append(newProductDetails)
                return .success
            } else {
                return .outOfStock
            }
        }

        if let index = selectedProduct.firstIndex(where: { $0.product.productId == product.product.productId }) {
            if selectedProduct[index].product.selectedCount < selectedProduct[index].product.quantity {
                var updatedProduct = selectedProduct[index].product
                updatedProduct.selectedCount += 1
                selectedProduct[index] = ProductDetails(product: updatedProduct, restaurant: product.restaurant)
                return .success
            } else {
                return .outOfStock
            }
        } else {
            return .differentProductExists
        }
    }



    
    func updateProduct(_ product: ProductDetails) {
        if let index = selectedProduct.firstIndex(where: { $0.product.productId == product.product.productId }) {
            selectedProduct[index] = product
        }
    }
    
    func removeProduct(_ product: ProductDetails) {
        if let index = selectedProduct.firstIndex(where: { $0.product.productId == product.product.productId }) {
            selectedProduct.remove(at: index)
        }
    }
    
    func removeAllProducts() {
        selectedProduct.removeAll()
    }
    
    func getProduct() -> [ProductDetails] {
        return selectedProduct
    }
    
    func isEmpty() -> Bool {
        return selectedProduct.isEmpty
    }
    
    func clearCart() {
        selectedProduct.removeAll()
        UserDefaults.standard.removeObject(forKey: cartKey)
    }
}

enum AddProductResult {
    case success
    case outOfStock
    case differentProductExists
}
