//
//  DeliveryViewModel.swift
//  CheapEats
//
//  Created by Emre on 22.03.2025.
//

import UIKit
import MapKit

protocol DeliveryViewModelProtocol {
    var delegate: DeliveryViewModelOutputProtocol? { get set }
    var cartItems: [ProductDetails] { get set }
    var totalAmount: Double { get set }
    var oldTotalAmount: Double { get set }
    func distanceCalculate(completion: @escaping (String) -> ())
    func deliveryType(_ deliveryTypeSegment: CustomSegmentedControl)
    func mapViewCenterCoordinate(mapView: MKMapView)
    func getAdress() -> String
}

protocol DeliveryViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class DeliveryViewModel {
    weak var delegate: DeliveryViewModelOutputProtocol?
    var cartItems: [ProductDetails] = []
    var totalAmount: Double = 0.0
    var oldTotalAmount: Double = 0.0
    
    func distanceCalculate(completion: @escaping (String) -> ()) {
        guard let restaurantLat = cartItems.first?.restaurant.location.latitude, let restaurantLon = cartItems.first?.restaurant.location.longitude, let userLat = LocationManager.shared.currentLatitude, let userLon = LocationManager.shared.currentLongitude else {
            completion("Hesaplanamadı")
            return
        }
        
        getRouteDistance(userLat: userLat, userLon: userLon, destLat: restaurantLat, destLon: restaurantLon) { distance in
            if distance < 1.0 {
                let meters = Int(distance * 1000)
                completion("\(meters)M")
            } else {
                completion(String(format: "%.1f KM", distance))
            }
        }
    }
    
    func deliveryType(_ deliveryTypeSegment: CustomSegmentedControl) {
        let deliveryType = cartItems.first?.product.deliveryType
        switch deliveryType {
        case .all:
            deliveryTypeSegment.setEnabled(true, forSegmentAt: 0)
            deliveryTypeSegment.setEnabled(true, forSegmentAt: 1)
            break
        case .delivery:
            deliveryTypeSegment.setEnabled(false, forSegmentAt: 0)
            deliveryTypeSegment.selectedSegmentIndex = 1
            break
        case .takeout:
            deliveryTypeSegment.setEnabled(false, forSegmentAt: 1)
            deliveryTypeSegment.selectedSegmentIndex = 0
            break
        default:
            break
        }
        deliveryTypeSegment.updateSegments()
    }
    
    func mapViewCenterCoordinate(mapView: MKMapView) {
        guard let cartItems = cartItems.first else { return }
        let location = CLLocationCoordinate2D(latitude: cartItems.restaurant.location.latitude, longitude: cartItems.restaurant.location.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = cartItems.restaurant.companyName
        annotation.subtitle = cartItems.product.name
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }
    
    func getAdress() -> String {
        guard let cartItems = cartItems.first else { return "" }
        return cartItems.restaurant.address
    }
}

extension DeliveryViewModel: DeliveryViewModelProtocol {}
