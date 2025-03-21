//
//  MapScreenViewModel.swift
//  CheapEats
//
//  Created by Emre on 1.02.2025.
//

import Foundation
import MapKit
import Firebase

protocol MapScreenViewModelProtocol {
    var delegate: MapScreenViewModelOutputProtocol? { get set}
    var latitude: Double? { get set }
    var longitude: Double? { get set }
    func centerMapToLocation(with mapView: MKMapView)
    func getUserCoordinate() -> CLLocationCoordinate2D?
    func addRestaurantPins(with mapView: MKMapView)
    func checkLocationCoordinate() -> Bool
    var productDetail: [ProductDetails] { get set }
    var restaurantDistances: [String: Double] { get set }
    var userAnnotation: MKPointAnnotation? { get }
    func createUserLocationAnnotation() -> MKPointAnnotation?
    func getFormattedDistance(for restaurantId: String) -> String
    func calculateAllDistances()
    var selectedRestaurantId: String? { get set }
    func selectRestaurant(withId id: String?)
    func isRestaurantSelected(_ restaurantId: String) -> Bool
    func selectRestaurantByAnnotationTitle(_ title: String?)
    func isCartEmpty(with cartButton: UIBarButtonItem)
}

protocol MapScreenViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func restaurantSelectionChanged()
}

final class MapScreenViewModel {
    weak var delegate: MapScreenViewModelOutputProtocol?
    var latitude: Double?
    var longitude: Double?
    private var _userAnnotation: MKPointAnnotation?
    var productDetail: [ProductDetails] = []
    var restaurantDistances: [String: Double] = [:]
    var _selectedRestaurantId: String?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCloseProductUpdated(_:)), name: NSNotification.Name("closeProductUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("closeProductUpdated"), object: nil)
    }
    
    @objc private func handleCloseProductUpdated(_ notification: Notification) {
        if let closeProducts = notification.object as? [ProductDetails] {
            self.productDetail = closeProducts
            self.delegate?.update()
        }
    }
    
    var userAnnotation: MKPointAnnotation? {
        return _userAnnotation
    }
    
    func centerMapToLocation(with mapView: MKMapView) {
        guard let latitude = latitude, let longitude = longitude else { return }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    
    func addRestaurantPins(with mapView: MKMapView) {
        for productDetail in productDetail {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: productDetail.restaurant.location.latitude, longitude: productDetail.restaurant.location.longitude)
            annotation.title = productDetail.restaurant.companyName
            annotation.subtitle = productDetail.product.name
            mapView.addAnnotation(annotation)
        }
    }
    
    private func updateLocation() {
        if let latitude = LocationManager.shared.currentLatitude,
           let longitude = LocationManager.shared.currentLongitude {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    func checkLocationCoordinate() -> Bool {
        updateLocation()
        if let _ = latitude, let _ = longitude {
            return true
        }
        return false
    }
    func getUserCoordinate() -> CLLocationCoordinate2D? {
        updateLocation()
        guard let latitude = self.latitude, let longitude = self.longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func createUserLocationAnnotation() -> MKPointAnnotation? {
        updateLocation()
        guard let latitude = self.latitude, let longitude = self.longitude else {
            return nil
        }
        
        let userLocation = MKPointAnnotation()
        userLocation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        userLocation.title = "Konumunuz"
        
        _userAnnotation = userLocation
        return userLocation
    }
    
    func calculateAllDistances() {
        guard checkLocationCoordinate() else { return }
        
        if let userLat = LocationManager.shared.currentLatitude,
           let userLon = LocationManager.shared.currentLongitude {
            
            let group = DispatchGroup()
            
            for product in productDetail {
                group.enter()
                getRouteDistance(userLat: userLat, userLon: userLon, destLat: product.restaurant.location.latitude,destLon: product.restaurant.location.longitude) { distance in
                    self.restaurantDistances[product.restaurant.restaurantId] = distance
                    group.leave()
                }
            }
            
            group.notify(queue: .main) { [weak self] in
                self?.delegate?.update()
            }
        }
    }
    func getFormattedDistance(for restaurantId: String) -> String {
        guard let distance = restaurantDistances[restaurantId] else {
            return "..."
        }
        
        if distance < 1.0 {
            let meters = Int(distance * 1000)
            return "\(meters)m"
        } else {
            return String(format: "%.1f km", distance)
        }
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
}
//Selected Restaurant Design
extension MapScreenViewModel {
    var selectedRestaurantId: String? {
        get {
            return _selectedRestaurantId
        }
        set {
            if _selectedRestaurantId != newValue {
                _selectedRestaurantId = newValue
                delegate?.restaurantSelectionChanged()
            }
        }
    }
    
    func selectRestaurant(withId id: String?) {
        selectedRestaurantId = id
    }
    
    func isRestaurantSelected(_ restaurantId: String) -> Bool {
        return selectedRestaurantId == restaurantId
    }
    
    func selectRestaurantByAnnotationTitle(_ title: String?) {
        guard let title = title else {
            selectedRestaurantId = nil
            return
        }
        
        if let productDetail = productDetail.first(where: { $0.restaurant.companyName == title }) {
            selectedRestaurantId = productDetail.restaurant.restaurantId
        }
    }
}

extension MapScreenViewModel: MapScreenViewModelProtocol {}
