//
//  OrdersDetailView.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation

protocol OrdersViewModelProtocol {
    var delegate: OrdersViewModelOutputProtocol? { get set}
    var orderDetailsList: [OrderDetail] { get set }
    func fetchData()
    func loadData()
}

protocol OrdersViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func updateTable()
    func startLoading()
    func stopLoading()
}

final class OrdersViewModel {
    weak var delegate: OrdersViewModelOutputProtocol?
    var orders: [UserOrder] = []
    var products: [Product]?
    var restaurants: [Restaurant]?
    var productDetailsList: [ProductDetails] = []
    var orderDetailsList: [OrderDetail] = []
    private let dispatchGroup = DispatchGroup()
    
    func fetchData() {
        self.delegate?.startLoading()
        orders.removeAll()
        products?.removeAll()
        productDetailsList.removeAll()
        restaurants?.removeAll()
        orderDetailsList.removeAll()
        dispatchGroup.enter()
        fetchOrders()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let productIds = self.orders.map { $0.productId }
            self.dispatchGroup.enter()
            self.fetchProducts(productIds: productIds)
            self.dispatchGroup.enter()
            self.fetchRestaurants()
            self.dispatchGroup.notify(queue: .main) { [weak self] in
                self?.delegate?.update()
                self?.delegate?.stopLoading()
            }
        }
    }
    
    private func fetchOrders() {
        NetworkManager.shared.fetchOrders { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let orders):
                self.orders = orders
            case .failure(let error):
                print(error)
                self.delegate?.error()
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func fetchProducts(productIds: [String]) {
        if productIds.isEmpty{
            dispatchGroup.leave()
            return
        }
        NetworkManager.shared.fetchSelectedProduct(productIds: productIds) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
        }
    }
    
    private func fetchRestaurants() {
        NetworkManager.shared.fetchRestaurant { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let restaurants):
                self.restaurants = restaurants
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
        }
    }
    
    private func combineProductAndRestaurantDetails(){
        if let products = products, let restaurants = restaurants{
            for product in products {
                if let restaurant = restaurants.first(where: { $0.restaurantId == product.restaurantId }) {
                    let productDetails = ProductDetails(product: product, restaurant: restaurant)
                    productDetailsList.append(productDetails)
                }
            }
        }
    }
    private func combineProductDetailAndOrderDetails() {
        combineProductAndRestaurantDetails()
        for userOrder in orders {
            if let productDetail = productDetailsList.first(where: { $0.product.productId == userOrder.productId }) {
                let orderDetail = OrderDetail(userOrder: userOrder, productDetail: productDetail)
                orderDetailsList.append(orderDetail)
            }
        }
    }
    
    func loadData() {
        combineProductDetailAndOrderDetails()
        delegate?.updateTable()
    }
}

extension OrdersViewModel: OrdersViewModelProtocol {}
