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
        //self.delegate?.startLoading()
        orders.removeAll()
        products?.removeAll()
        productDetailsList.removeAll()
        restaurants?.removeAll()
        dispatchGroup.enter()
        fetchOrders()
        dispatchGroup.enter()
        let productIds = orders.map { $0.productId }
        fetchProducts(productIds: productIds)
        dispatchGroup.enter()
        fetchRestaurants()
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.delegate?.update()
            //self?.delegate?.stopLoading()
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
            dispatchGroup.leave()
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
    
    
    //[Orders(orderNumber: "1234987", company: "Burger King", food: "Whopper", date: "12.12.2024", imageUrl: "testImage", oldAmount: "200", newAmount: "150", orderStatus: .preparing), Orders(orderNumber: "9871234", company: "KFC", food: "Twister", date: "12.12.2024", imageUrl: "testImage3", oldAmount: "100", newAmount: "80", orderStatus: .delivered), Orders(orderNumber: "343123412", company: "McDonald's", food: "Big Mac", date: "12.12.2024", imageUrl: "testImage4", oldAmount: "150", newAmount: "120", orderStatus: .canceled)]
}

extension OrdersViewModel: OrdersViewModelProtocol {}
