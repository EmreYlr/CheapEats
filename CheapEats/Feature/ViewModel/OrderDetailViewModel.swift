//
//  OrderDetailViewModel.swift
//  CheapEats
//
//  Created by Emre on 14.12.2024.
//

import Foundation
import MapKit
import UIKit

protocol OrderDetailViewModelProtocol {
    var delegate: OrderDetailViewModelOutputProtocol? { get set}
    var order: OrderDetail? { get set }
    var coupon: Coupon? { get set }
    var totalAmount: Double { get set }
    func viewLocated()
    func createPdfData(from view: UIView) -> NSMutableData?
    func savePdf(data: NSMutableData, fileName: String, completion: @escaping (URL?) -> Void)
    func getCoupon()
    func checkDeliveryType() -> Bool
}

protocol OrderDetailViewModelOutputProtocol: AnyObject {
    func update()
    func couponUpdated()
    func errorCoupon()
    func error()
}

final class OrderDetailViewModel {
    weak var delegate: OrderDetailViewModelOutputProtocol?
    var order: OrderDetail?
    var coupon: Coupon?
    var totalAmount: Double = 0.0
    
    func viewLocated() {
        if let currentLat = LocationManager.shared.currentLatitude,
           let currentLon = LocationManager.shared.currentLongitude,
           let destinationLat = order?.productDetail.restaurant.location.latitude,
           let destinationLon = order?.productDetail.restaurant.location.longitude
        {
            let currentLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLon))
            let destination = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLon))
            let mapItemCurrentLocation = MKMapItem(placemark: currentLocation)
            let mapItemDestination = MKMapItem(placemark: destination)
            mapItemCurrentLocation.name = "Current Location"
            mapItemDestination.name = order?.productDetail.restaurant.companyName ?? "Target"
            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMaps(with: [mapItemCurrentLocation, mapItemDestination], launchOptions: options)
        }
        else {
            self.delegate?.error()
        }
    }
    
    func createPdfData(from view: UIView) -> NSMutableData? {
        return PDFHelper.createPdfFromView(view: view)
    }
    
    func savePdf(data: NSMutableData, fileName: String, completion: @escaping (URL?) -> Void) {
        PDFHelper.savePdf(data: data, fileName: fileName, completion: completion)
    }
    
    func getCoupon() {
        totalAmount = order?.productDetail.product.newPrice ?? 0.0
        guard let id = order?.userOrder.couponId, !id.isEmpty else {
            self.delegate?.errorCoupon()
            return
        }
        NetworkManager.shared.fetchCouponById(id: id) { result in
            switch result {
            case .success(let coupon):
                self.coupon = coupon
                self.totalAmount *= Double(self.order?.userOrder.quantity ?? 1)
                self.totalAmount -= Double(coupon.discountValue)
                self.delegate?.couponUpdated()
            case .failure(_):
                self.delegate?.errorCoupon()
            }
        }
    }
    
    func checkDeliveryType() -> Bool {
        guard let order = order else {
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
}

extension OrderDetailViewModel: OrderDetailViewModelProtocol {}
