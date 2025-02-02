//
//  MapScreenViewController.swift
//  CheapEats
//
//  Created by Emre on 1.02.2025.
//

import UIKit
import MapKit

final class MapScreenViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var mapView: MKMapView!
    let mapScreenViewModel: MapScreenViewModelProtocol = MapScreenViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapScreenViewController")
        setupMap()
    }
    
    private func setupMap() {
        // Kaydedilen konum bilgilerini al ve haritayı güncelle
        if let latitude = LocationManager.shared.currentLatitude,
           let longitude = LocationManager.shared.currentLongitude {
            mapScreenViewModel.updateLocation(latitude: latitude, longitude: longitude)
            self.mapScreenViewModel.centerMapToLocation(mapView: self.mapView)
        }
    }
    
}
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
