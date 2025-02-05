//
//  DetailViewModel.swift
//  CheapEats
//
//  Created by Emre on 29.11.2024.
//

import Foundation
import MapKit

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelOutputProtocol? { get set }
    var productDetail: ProductDetails? { get set }
    func getRoutuerDistance(completion: @escaping(String) -> Void)
    func mapViewCenterCoordinate(mapView: MKMapView)
}
protocol DetailViewModelOutputProtocol: AnyObject {
    //TODO: Loading ekle
    func update()
    func error()
}

final class DetailViewModel {
    weak var delegate: DetailViewModelOutputProtocol?
    var productDetail: ProductDetails?
    
    func mapViewCenterCoordinate(mapView: MKMapView) {
        if let productDetail = productDetail {
            let location = CLLocationCoordinate2D(latitude: productDetail.restaurant.location.latitude, longitude: productDetail.restaurant.location.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = productDetail.restaurant.name
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 800, longitudinalMeters: 800)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func getRoutuerDistance(completion: @escaping(String) -> Void){
        if let userLatitude = LocationManager.shared.currentLatitude, let userLongitude = LocationManager.shared.currentLongitude, let destinationLatitude = productDetail?.restaurant.location.latitude,  let destinationLongitude = productDetail?.restaurant.location.longitude {
            getRouteDistance(userLat: userLatitude, userLon: userLongitude, destLat: destinationLatitude, destLon: destinationLongitude) { distance in
                if distance < 1 {
                    let distanceTemp = Int(distance * 1000)
                    let returnDistance = "\(distanceTemp) M"
                    completion(returnDistance)
                }  else{
                    let truncatedDistance = floor(distance * 100) / 100
                    let returnDistance = String(format: "%.1f KM", truncatedDistance)
                    completion(returnDistance)
                }
            }
        }
        else {
            completion("0 M")
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol { }
