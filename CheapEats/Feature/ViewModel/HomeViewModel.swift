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
    var endlingProduct: [Product]? { get set }
    var recommendedProduct: [Product]? { get set }
    var closeProduct: [Product]? { get set }
    func fetchProducts()
    func checkLocationPermission(with locationManager: CLLocationManager) -> Bool
}

protocol HomeViewModelOutputProtocol: AnyObject{
    func update()
    func error()
}

final class HomeViewModel {
    weak var delegate: HomeViewModelOutputProtocol?
    var user: Users?
    //TODO: -Sadece product çek sonrasında filtreleme işlemlerini yap.
    //var product: [Product]?
    var endlingProduct: [Product]?
    var recommendedProduct: [Product]?
    var closeProduct: [Product]?

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
    
    func fetchProducts() {
        NetworkManager.shared.fetchProducts { products, error in
            if let error = error {
                print("Error fetching products: \(error)")
                self.delegate?.error()
            } else if let products = products {
                self.endlingProduct = products
                self.recommendedProduct = products
                self.closeProduct = products
                self.delegate?.update()
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol { }
