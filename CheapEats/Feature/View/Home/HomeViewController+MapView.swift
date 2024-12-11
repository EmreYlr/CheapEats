//
//  HomeViewController+MapView.swift
//  CheapEats
//
//  Created by Emre on 11.12.2024.
//

import Foundation
import MapKit
import CoreLocation

extension HomeViewController {
    
    //Uzaklık hesaplama metodu
    /*
     let userLatitude = 37.165952
     let userLongitude = 38.795954
     let destinationLatitude = 37.169876
     let destinationLongitude = 38.810689
     
     getRouteDistance(userLat: userLatitude, userLon: userLongitude, destLat: destinationLatitude, destLon: destinationLongitude) { distance in
         print(distance != nil ? "Yol mesafesi: \(distance!) km" : "Mesafe hesaplanamadı.")
     }
     
     
     func getRouteDistance(userLat: Double, userLon: Double, destLat: Double, destLon: Double, completion: @escaping (Double?) -> Void) {
         let request = MKDirections.Request()
         request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLon)))
         request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destLat, longitude: destLon)))
         request.transportType = .walking
         
         MKDirections(request: request).calculate { response, _ in
             if let distance = response?.routes.first?.distance {
                 completion(distance / 1000)
             } else {
                 completion(nil)
             }
         }
     }
     */
}
