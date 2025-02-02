//
//  MapScreenViewModel.swift
//  CheapEats
//
//  Created by Emre on 1.02.2025.
//

import Foundation
import MapKit

protocol MapScreenViewModelProtocol {
    var delegate: MapScreenViewModelOutputProtocol? { get set}
    var latitude: Double? { get set }
    var longitude: Double? { get set }
    func centerMapToLocation(with mapView: MKMapView)
    func checkLocationCoordinate() -> Bool
}

protocol MapScreenViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MapScreenViewModel {
    weak var delegate: MapScreenViewModelOutputProtocol?
    var latitude: Double?
    var longitude: Double?
    
    func centerMapToLocation(with mapView: MKMapView) {
        guard let latitude = latitude, let longitude = longitude else { return }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Burdasın"
        mapView.showsUserTrackingButton = true
        mapView.addAnnotation(annotation)
        
    }
    
    private func updateLocation() {
        if let latitude = LocationManager.shared.currentLatitude,
           let longitude = LocationManager.shared.currentLongitude {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    func checkLocationCoordinate() -> Bool {
        updateLocation()
        if let _ = latitude, let _ = longitude {
            return true
        }
        return false
    }
}


extension MapScreenViewModel: MapScreenViewModelProtocol {}
