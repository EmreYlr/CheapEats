//
//  HomeViewModel.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import Foundation
import CoreLocation
import UIKit

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelOutputProtocol? { get set }
    var user: Users? { get set }
    var productDetailsList: [ProductDetails] { get set }
    var endlingProduct: [ProductDetails] { get set }
    var recommendedProduct: [ProductDetails] { get set }
    var closeProduct: [ProductDetails] { get set }
    func fetchData()
    func refreshUserData()
    func combineProductAndRestaurantDetails()
    func collectionLoad()
    func checkLocationPermission(with locationManager: CLLocationManager) -> Bool
    func isCartEmpty(with cartButton: UIBarButtonItem)
}

protocol HomeViewModelOutputProtocol: AnyObject{
    func update()
    func updateCollection()
    func updateCloseProduct()
    func error()
    func startLoading()
    func stopLoading()
}

final class HomeViewModel {
    weak var delegate: HomeViewModelOutputProtocol?
    var user: Users?
    var products: [Product]?
    var restaurants: [Restaurant]?
    var productDetailsList: [ProductDetails] = []
    var endlingProduct: [ProductDetails] = []
    var recommendedProduct: [ProductDetails] = []
    var closeProduct: [ProductDetails] = []
    private let dispatchGroup = DispatchGroup()
    
    init() {
        self.user = UserManager.shared.user
    }
    func refreshUserData() {
        self.user = UserManager.shared.user
    }
    
    
    func checkLocationPermission(with locationManager: CLLocationManager) -> Bool{
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            return true
        case .denied, .restricted:
            print("Konum izni verilmedi. Ayarlardan izin verin.")
            return false
        @unknown default:
            print("Bilinmeyen bir izin durumu.")
            return false
        }
        return false
    }
    
    func fetchData() {
        self.delegate?.startLoading()
        products?.removeAll()
        endlingProduct.removeAll()
        recommendedProduct.removeAll()
        closeProduct.removeAll()
        productDetailsList.removeAll()
        restaurants?.removeAll()
        dispatchGroup.enter()
        fetchProducts()
        dispatchGroup.enter()
        fetchRestaurants()
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.delegate?.update()
            self?.delegate?.stopLoading()
        }
        
    }
    
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                self.handleError(error)
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
                self.handleError(error)
            }
            dispatchGroup.leave()
        }
    }
    
    func combineProductAndRestaurantDetails(){
        if let products = products, let restaurants = restaurants {
            for product in products {
                if let restaurant = restaurants.first(where: { $0.restaurantId == product.restaurantId }) {
                    let productDetails = ProductDetails(product: product, restaurant: restaurant)
                    productDetailsList.append(productDetails)
                }
            }
        }
    }
    
    func collectionLoad() {
        combineProductAndRestaurantDetails()
        
        endlingProduct = productDetailsList
        endlingProductsSort()
        
        recommendedProduct = productDetailsList
        recommendedProductsSort()
        
        closeProduct = productDetailsList
        closeProductSort()
                
        self.delegate?.updateCollection()
    }
    
    private func handleError(_ error: CustomError) {
        switch error {
        case .invalidDocument:
            print("Invalid document structure")
        case .decodingError:
            print("Error decoding data")
        case .noData:
            print("No data found")
        case .networkError(let error):
            print("Network error: \(error.localizedDescription)")
        }
        self.delegate?.error()
    }
    
    func isCartEmpty(with cartButton: UIBarButtonItem) {
        if CartManager.shared.isEmpty() {
            cartButton.image = UIImage(systemName: "cart")
            BadgeManager.shared.removeBadge(from: cartButton)
        } else {
            cartButton.image = UIImage(systemName: "cart.fill")
            let count = CartManager.shared.getProduct().count
            BadgeManager.shared.updateBadge(on: cartButton, count: count)
        }
    }
    
    private func endlingProductsSort() {
        endlingProduct.sort {
            $0.product.createdAt > $1.product.createdAt
        }
    }
    
    private func recommendedProductsSort() {
        recommendedProduct.sort {
            $0.product.newPrice < $1.product.newPrice
        }
    }
    
    private func closeProductSort() {
        distanceCalculate(with: endlingProduct) { [weak self] result in
            self?.closeProduct = result
                .sorted { $0.1 < $1.1 }
                .map { $0.0 }
            
            self?.delegate?.updateCloseProduct()
            
            NotificationCenter.default.post(name: NSNotification.Name("closeProductUpdated"), object: self?.closeProduct)
        }
        
    }
    
    private func distanceCalculate(with productDetails: [ProductDetails], completion: @escaping ([(ProductDetails, Double)]) -> Void) {
        var results: [(ProductDetails, Double)] = []
        var completedCount = 0
        
        guard let userLat = LocationManager.shared.currentLatitude,
              let userLon = LocationManager.shared.currentLongitude else {
            completion([])
            return
        }
        
        let totalCount = productDetails.count
        guard totalCount > 0 else {
            completion([])
            return
        }
        
        for detail in productDetails {
            getRouteDistance(userLat: userLat, userLon: userLon,
                             destLat: detail.restaurant.location.latitude,
                             destLon: detail.restaurant.location.longitude) { distance in
                results.append((detail, distance))
                completedCount += 1
                
                if completedCount == totalCount {
                    completion(results)
                }
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol { }
