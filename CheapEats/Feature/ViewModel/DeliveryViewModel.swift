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
    var takeoutPrice: Double { get set }
    var orderDetail: OrderDetail? { get set }
    
    func distanceCalculate(completion: @escaping (String) -> ())
    func deliveryType(_ deliveryTypeSegment: CustomSegmentedControl, mapView: MKMapView, addressLabel: UILabel, addressStateLabel: UILabel, totalAmount: UILabel, deliveryWarningLabel: UILabel, deliveryStateLabel: UILabel)
    func selectedDeliveryType(at index: Int, mapView: MKMapView, addressLabel: UILabel, addressStateLabel: UILabel, totalAmount: UILabel, deliveryWarningLabel: UILabel, deliveryStateLabel: UILabel)
    func mapViewCenterRestaurantCoordinate(mapView: MKMapView)
    func mapViewCenterUserCoordinate(mapView: MKMapView)
    func getRestaurantAddress() -> String
    func getUserAddress() -> String
    func createOrder(at index: Int)
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
    var takeoutPrice: Double = 0.0
    var orderDetail: OrderDetail?
    
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
    
    func deliveryType(_ deliveryTypeSegment: CustomSegmentedControl, mapView: MKMapView, addressLabel: UILabel, addressStateLabel: UILabel, totalAmount: UILabel, deliveryWarningLabel: UILabel, deliveryStateLabel: UILabel) {
        let deliveryType = cartItems.first?.product.deliveryType
        switch deliveryType {
        case .all:
            deliveryTypeSegment.setEnabled(true, forSegmentAt: 0)
            deliveryTypeSegment.setEnabled(true, forSegmentAt: 1)
            deliveryTypeSegment.selectedSegmentIndex = 0
            deliveryStateLabel.isHidden = true
            break
        case .delivery:
            deliveryTypeSegment.setEnabled(false, forSegmentAt: 0)
            deliveryTypeSegment.selectedSegmentIndex = 1
            deliveryStateLabel.isHidden = false
            deliveryStateLabel.text = "(Bu restorantda Kurye hizmeti bulunmamaktadır)"
            break
        case .takeout:
            deliveryTypeSegment.setEnabled(false, forSegmentAt: 1)
            deliveryTypeSegment.selectedSegmentIndex = 0
            deliveryStateLabel.isHidden = false
            deliveryStateLabel.text = "(Bu restorantda Gel-Al hizmeti bulunmamaktadır)"
            break
        default:
            deliveryTypeSegment.selectedSegmentIndex = 0
            break
        }
        deliveryTypeSegment.updateSegments()
        selectedDeliveryType(at: deliveryTypeSegment.selectedSegmentIndex, mapView: mapView, addressLabel: addressLabel, addressStateLabel: addressStateLabel, totalAmount: totalAmount, deliveryWarningLabel: deliveryWarningLabel, deliveryStateLabel: deliveryStateLabel)
    }
    
    func mapViewCenterRestaurantCoordinate(mapView: MKMapView) {
        guard let cartItems = cartItems.first else { return }
        mapView.removeAnnotations(mapView.annotations)
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
        mapView.removeAnnotations(mapView.annotations)
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
    
    func selectedDeliveryType(at index: Int, mapView: MKMapView, addressLabel: UILabel, addressStateLabel: UILabel, totalAmount: UILabel, deliveryWarningLabel: UILabel, deliveryStateLabel: UILabel) {
        
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
    
    func createOrder(at index: Int) {
        var selectedDeliveryType = DeliveryType.all
        switch index {
        case 0:
            selectedDeliveryType = .takeout
            takeoutPrice = 20.0
        case 1:
            selectedDeliveryType = .delivery
            takeoutPrice = 0.0
        default:
            delegate?.error()
        }
        
        let userId = UserManager.shared.getUserId()
        //TODO: -productID array gidecek
        let userOrder = UserOrder(productId: cartItems.first!.product.productId, userId: userId, restaurantId: cartItems.first!.restaurant.restaurantId, selectedDeliveryType: selectedDeliveryType)
        
        //TODO: -productDetail array gidecek
        let orderDetail = OrderDetail(userOrder: userOrder, productDetail: cartItems.first!)
        self.orderDetail = orderDetail
        
        delegate?.update()
    }
}

extension DeliveryViewModel: DeliveryViewModelProtocol {}
