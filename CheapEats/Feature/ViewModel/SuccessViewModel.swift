//
//  SuccessViewModel.swift
//  CheapEats
//
//  Created by Emre on 2.06.2025.
//
import MapKit

protocol SuccessViewModelProtocol {
    var delegate: SuccessViewModelOutputProtocol? {get set}
    var orderDetail: OrderDetail? { get set }
    func goLocation()
    func updateCart()
}

protocol SuccessViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class SuccessViewModel {
    weak var delegate: SuccessViewModelOutputProtocol?
    var orderDetail: OrderDetail?
    
    func goLocation() {
        guard let restaurant = orderDetail?.productDetail.restaurant else {
            delegate?.error()
            return
        }
        let latitude: CLLocationDegrees =  restaurant.location.latitude
        let longitude: CLLocationDegrees = restaurant.location.longitude
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        destination.name = restaurant.companyName
        
        destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func updateCart() {
        CartManager.shared.clearCart()
    }
}

extension SuccessViewModel: SuccessViewModelProtocol {}

