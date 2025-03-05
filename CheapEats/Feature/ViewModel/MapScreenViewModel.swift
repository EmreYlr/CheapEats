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
    var userAnnotation: MKPointAnnotation? { get }
    func createUserLocationAnnotation() -> MKPointAnnotation?
}

protocol MapScreenViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MapScreenViewModel {
    weak var delegate: MapScreenViewModelOutputProtocol?
    var latitude: Double?
    var longitude: Double?
    private var _userAnnotation: MKPointAnnotation?
    var productDetail: [ProductDetails] = []
    
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
}

extension MapScreenViewModel: MapScreenViewModelProtocol {}
