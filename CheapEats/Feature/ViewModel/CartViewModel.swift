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
    var totalAmount: Double { get }
    var oldTotalAmount: Double { get }
    func updateCount(product: ProductDetails, count: Int)
    func getCartItems()
    func deleteProduct(product: ProductDetails)
    func clearCart()
}

protocol CartViewModelOutputProtocol: AnyObject {
    func update()
    func emptyCart()
    func reloadTotalAmount()
    func error()
    func startLoading()
    func stopLoading()
}

final class CartViewModel {
    weak var delegate: CartViewModelOutputProtocol?
    var cartItems: [ProductDetails] = []
    //TODO: old amount da olabilir
    var totalAmount: Double {
        return cartItems.reduce(0.0) { sum, productDetails in
            sum + (productDetails.product.newPrice * Double(productDetails.product.selectedCount))
        }
    }
    var oldTotalAmount: Double {
        return cartItems.reduce(0.0) { sum, productDetails in
            sum + (productDetails.product.oldPrice * Double(productDetails.product.selectedCount))
        }
    }
    
    func getCartItems() {
        cartItems.removeAll()
        cartItems = CartManager.shared.getProduct()
        if isCartEmpty() {
            delegate?.emptyCart()
        } else{
            delegate?.update()
            delegate?.reloadTotalAmount()
        }
    }
    
    func updateCount(product: ProductDetails, count: Int) {
        if let index = cartItems.firstIndex(where: { $0.product.productId == product.product.productId }) {
            
            var updatedProduct = product.product
            updatedProduct.selectedCount = count
            
            let updatedProductDetails = ProductDetails(product: updatedProduct, restaurant: product.restaurant)
            
            cartItems[index] = updatedProductDetails
            CartManager.shared.updateProduct(updatedProductDetails)
            delegate?.reloadTotalAmount()
        }
    }
    
    func deleteProduct(product: ProductDetails) {
        if let index = cartItems.firstIndex(where: { $0.product.productId == product.product.productId }) {
            cartItems.remove(at: index)
            CartManager.shared.removeProduct(product)
            delegate?.reloadTotalAmount()
        }
    }
    
    private func isCartEmpty() -> Bool {
        return cartItems.isEmpty
    }
    func clearCart() {
        CartManager.shared.clearCart()
        cartItems.removeAll()
        delegate?.emptyCart()
    }
}

extension CartViewModel: CartViewModelProtocol {}
