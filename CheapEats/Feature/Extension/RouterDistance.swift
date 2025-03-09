//
//  Router.swift
//  CheapEats
//
//  Created by Emre on 5.02.2025.
//

import MapKit

protocol RouterDistance {
    func getRouteDistance(userLat: Double, userLon: Double, destLat: Double, destLon: Double, completion: @escaping (Double) -> Void)
}

extension RouterDistance {
    func getRouteDistance(userLat: Double, userLon: Double, destLat: Double, destLon: Double, completion: @escaping (Double) -> Void) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLon)))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destLat, longitude: destLon)))
        request.transportType = .walking
        
        MKDirections(request: request).calculate { response, _ in
            if let distance = response?.routes.first?.distance {
                completion(distance / 1000)
            } else {
                completion(0)
            }
        }
    }
}
extension DetailViewModel: RouterDistance {}
extension MoreViewModel: RouterDistance {}
extension MapScreenViewModel: RouterDistance {}

