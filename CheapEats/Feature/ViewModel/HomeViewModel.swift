//
//  HomeViewModel.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import Foundation
import CoreLocation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelOutputProtocol? { get set }
    var user: Users? { get set }
    var products: [Product]? { get set }
    var restaurants: [Restaurant]? { get set }
    var productDetailsList: [ProductDetails] { get set }
    var endlingProduct: [ProductDetails] { get set }
    var recommendedProduct: [ProductDetails] { get set }
    var closeProduct: [ProductDetails] { get set }
    func fetchData()
    func combineProductAndRestaurantDetails()
    func collectionLoad()
    func checkLocationPermission(with locationManager: CLLocationManager) -> Bool
}

protocol HomeViewModelOutputProtocol: AnyObject{
    //TODO: Loading ekle
    func update()
    func updateCollection()
    func error()
}

final class HomeViewModel {
    weak var delegate: HomeViewModelOutputProtocol?
    var user: Users?
    //TODO: -Sadece product çek sonrasında filtreleme işlemlerini yap.
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
        dispatchGroup.enter()
        fetchProducts()
        dispatchGroup.enter()
        fetchRestaurants()
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.delegate?.update()
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
        //endlingProduct = productDetailsList.filter { $0.product.createdAt > Date().addingTimeInterval(-86400) }
        recommendedProduct = productDetailsList
        //recommendedProduct = productDetailsList.filter { $0.product.rating > 4.0 }
        closeProduct = productDetailsList
        //closeProduct = productDetailsList.filter { $0.restaurant.distance < 5.0 }
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
}

extension HomeViewModel: HomeViewModelProtocol { }
