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
    func centerMapToLocation(mapView: MKMapView)
    func updateLocation(latitude: Double, longitude: Double)
}

protocol MapScreenViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MapScreenViewModel {
    weak var delegate: MapScreenViewModelOutputProtocol?
    var latitude: Double?
    var longitude: Double?
    
    func updateLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func centerMapToLocation(mapView: MKMapView) {
        guard let latitude = latitude, let longitude = longitude else { return }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Konumunuz"
        mapView.addAnnotation(annotation)
    }
}

extension MapScreenViewModel: MapScreenViewModelProtocol {}
