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
    var mockRestaurants: [Restaurant] { get set }
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
    var mockRestaurants: [Restaurant] = [
            Restaurant(dictionary: [
                "companyName": "Gourmet Heaven",
                "ownerName": "Ali",
                "ownerSurname": "Veli",
                "address": "123 Atatürk Bulvarı, Şahinbey, Gaziantep",
                "email": "ali.veli@gourmetheaven.com",
                "phone": "555-1234",
                "location": GeoPoint(latitude: 37.058, longitude: 37.382),
                "createdAt": Timestamp(date: Date())
            ], documentId: "1")!,
            
            Restaurant(dictionary: [
                "companyName": "Seafood Delight",
                "ownerName": "Ayşe",
                "ownerSurname": "Yılmaz",
                "address": "456 Cumhuriyet Caddesi, Şahinbey, Gaziantep",
                "email": "ayse.yilmaz@seafooddelight.com",
                "phone": "555-5678",
                "location": GeoPoint(latitude: 37.065, longitude: 37.375),
                "createdAt": Timestamp(date: Date())
            ], documentId: "2")!,
            
            Restaurant(dictionary: [
                "companyName": "Veggie Paradise",
                "ownerName": "Mehmet",
                "ownerSurname": "Kara",
                "address": "789 Karataş Mahallesi, Şahinbey, Gaziantep",
                "email": "mehmet.kara@veggieparadise.com",
                "phone": "555-9101",
                "location": GeoPoint(latitude: 37.042, longitude: 37.358),
                "createdAt": Timestamp(date: Date())
            ], documentId: "3")!,
            
            Restaurant(dictionary: [
                "companyName": "Steak House",
                "ownerName": "Fatma",
                "ownerSurname": "Demir",
                "address": "321 Güneykent Mahallesi, Şahinbey, Gaziantep",
                "email": "fatma.demir@steakhouse.com",
                "phone": "555-1122",
                "location": GeoPoint(latitude: 37.028, longitude: 37.391),
                "createdAt": Timestamp(date: Date())
            ], documentId: "4")!,
            
            Restaurant(dictionary: [
                "companyName": "Pizza Palace",
                "ownerName": "Ahmet",
                "ownerSurname": "Çelik",
                "address": "654 23 Nisan Mahallesi, Şahinbey, Gaziantep",
                "email": "ahmet.celik@pizzapalace.com",
                "phone": "555-3344",
                "location": GeoPoint(latitude: 37.073, longitude: 37.362),
                "createdAt": Timestamp(date: Date())
            ], documentId: "5")!
        ]
    
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
        for restaurant in mockRestaurants {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
            annotation.title = restaurant.companyName
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
