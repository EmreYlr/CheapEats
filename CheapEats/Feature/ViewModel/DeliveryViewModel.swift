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
    func deliveryType(_ deliveryTypeSegment: CustomSegmentedControl, mapView: MKMapView, addressLabel: UILabel, addressStateLabel: UILabel, totalAmount: UILabel, deliveryWarningLabel: UILabel)
    func selectedDeliveryType(at index: Int, mapView: MKMapView, addressLabel: UILabel, addressStateLabel: UILabel, totalAmount: UILabel, deliveryWarningLabel: UILabel)
    func mapViewCenterRestaurantCoordinate(mapView: MKMapView)
    func mapViewCenterUserCoordinate(mapView: MKMapView)
    func getRestaurantAddress() -> String
    func getUserAddress() -> String
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
    
    func deliveryType(_ deliveryTypeSegment: CustomSegmentedControl, mapView: MKMapView, addressLabel: UILabel, addressStateLabel: UILabel, totalAmount: UILabel, deliveryWarningLabel: UILabel) {
        let deliveryType = cartItems.first?.product.deliveryType
        switch deliveryType {
        case .all:
            deliveryTypeSegment.setEnabled(true, forSegmentAt: 0)
            deliveryTypeSegment.setEnabled(true, forSegmentAt: 1)
            deliveryTypeSegment.selectedSegmentIndex = 0
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
            deliveryTypeSegment.selectedSegmentIndex = 0
            break
        }
        deliveryTypeSegment.updateSegments()
        selectedDeliveryType(at: deliveryTypeSegment.selectedSegmentIndex, mapView: mapView, addressLabel: addressLabel, addressStateLabel: addressStateLabel, totalAmount: totalAmount, deliveryWarningLabel: deliveryWarningLabel)
    }
    
    func mapViewCenterRestaurantCoordinate(mapView: MKMapView) {
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
    
    func mapViewCenterUserCoordinate(mapView: MKMapView) {
        guard let userLocation = LocationManager.shared.currentLocation else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation
        annotation.title = "Konumunuz"
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }
    
    func getRestaurantAddress() -> String {
        guard let cartItems = cartItems.first else { return "" }
        return cartItems.restaurant.address
    }
    
    func getUserAddress() -> String {
        return LocationManager.shared.currentAddress ?? "Adress alınamadı"
    }
    
    func selectedDeliveryType(at index: Int, mapView: MKMapView, addressLabel: UILabel, addressStateLabel: UILabel, totalAmount: UILabel, deliveryWarningLabel: UILabel) {
        
        totalAmount.text = "\(formatDouble(self.totalAmount)) TL"
        switch index {
        case 0:
            mapViewCenterUserCoordinate(mapView: mapView)
            addressLabel.text = getUserAddress()
            addressStateLabel.text = "Adresiniz:"
            totalAmount.text = "\(formatDouble(self.totalAmount + 20)) TL"
            deliveryWarningLabel.isHidden = false
        case 1:
            mapViewCenterRestaurantCoordinate(mapView: mapView)
            addressLabel.text = getRestaurantAddress()
            addressStateLabel.text = "Restorant Adresi:"
            totalAmount.text = totalAmount.text ?? ""
            deliveryWarningLabel.isHidden = true
        default:
            break
        }
    }
}

extension DeliveryViewModel: DeliveryViewModelProtocol {}
