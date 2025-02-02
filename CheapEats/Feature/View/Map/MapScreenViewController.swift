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
    
    @IBOutlet weak var accessView: UIView!
    
    @IBOutlet weak var accessButon: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var mapScreenViewModel: MapScreenViewModelProtocol = MapScreenViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapScreenViewController")
        mapScreenViewModel.delegate = self
        initLoad()
        setupMap()
        
    }
    
    private func initLoad() {
        mapView.layer.cornerRadius = 10
        if mapScreenViewModel.checkLocationCoordinate() {
            accessView.isHidden = true
            mapView.isHidden = false
        } else{
            accessView.isHidden = false
            mapView.isHidden = true
        }
    }
    
    private func setupMap() {
        mapScreenViewModel.centerMapToLocation(with: mapView)
    }
    
    @IBAction func accessButonClicked(_ sender: UIButton) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
extension MapScreenViewController: MapScreenViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
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
