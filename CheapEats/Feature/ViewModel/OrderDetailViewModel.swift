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
    func viewLocated()
    func createPdfData(from view: UIView) -> NSMutableData?
    func savePdf(data: NSMutableData, fileName: String, completion: @escaping (URL?) -> Void)
}

protocol OrderDetailViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class OrderDetailViewModel {
    weak var delegate: OrderDetailViewModelOutputProtocol?
    var order: OrderDetail?
    
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
}

extension OrderDetailViewModel: OrderDetailViewModelProtocol {}
