//
//  CartManager.swift
//  CheapEats
//
//  Created by Emre on 10.03.2025.
//

import Foundation

final class CartManager {
    static let shared = CartManager()
    
    private init() { selectedProduct = [] }
    
    var selectedProduct: [ProductDetails] = []
    //TODO: -Farklı restorantdan ürün eklenmeyecek
    func addProduct(_ product: ProductDetails) {
        if let index = selectedProduct.firstIndex(where: { $0.product.productId == product.product.productId }) {
            if selectedProduct[index].product.selectedCount < selectedProduct[index].product.quantity {
                var updatedProduct = selectedProduct[index].product
                updatedProduct.selectedCount += 1
                selectedProduct[index] = ProductDetails(product: updatedProduct, restaurant: product.restaurant)
            }
        } else {
            if product.product.quantity > 0 {
                var updatedProduct = product.product
                updatedProduct.selectedCount = 1
                let newProductDetails = ProductDetails(product: updatedProduct, restaurant: product.restaurant)
                selectedProduct.append(newProductDetails)
            }
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
}

