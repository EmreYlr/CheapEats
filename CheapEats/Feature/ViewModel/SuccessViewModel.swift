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
    var coupon: Coupon? { get set }
    func goLocation()
    func updateCart()
    func getCoupon() -> String
    func isCouponAvailable() -> Bool
    func checkDeliveryType() -> Bool
    var totalAmount: Double { get set }
}

protocol SuccessViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class SuccessViewModel {
    weak var delegate: SuccessViewModelOutputProtocol?
    var orderDetail: OrderDetail?
    var coupon: Coupon?
    var totalAmount: Double = 0.0
    
    func getCoupon() -> String {
        totalAmount = orderDetail?.productDetail.product.newPrice ?? 0.0
        if let coupon = coupon {
            totalAmount *= Double(self.orderDetail?.userOrder.quantity ?? 1)
            totalAmount -= Double(coupon.discountValue)
            return "\(coupon.discountValue) TL"
        } else {
            return ""
        }
    }
    
    func checkDeliveryType() -> Bool {
        guard let order = orderDetail else {
            return false
        }
        switch order.userOrder.selectedDeliveryType {
        case .delivery:
            return false
        case .takeout:
            self.totalAmount += 20.0
            return true
        case .all:
            return false
        }
    }
    
    func isCouponAvailable() -> Bool {
        return !(coupon != nil)
    }
    
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

