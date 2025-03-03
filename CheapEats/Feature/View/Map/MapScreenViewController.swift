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
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapScreenViewController")
        mapScreenViewModel.delegate = self
        initLoad()
        setupMap()
        
    }
    
    private func initLoad() {
        if mapScreenViewModel.checkLocationCoordinate() {
            accessView.isHidden = true
            mapView.isHidden = false
        } else{
            accessView.isHidden = false
            mapView.isHidden = true
        }
    }
    
    private func setupMap() {
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsTraffic = false
        mapView.showsBuildings = false
        mapView.showsLargeContentViewer = false
        //mapView.showsUserLocation = true
        mapScreenViewModel.centerMapToLocation(with: mapView)
        addRestaurantPins()
    }
    
    @IBAction func accessButonClicked(_ sender: UIButton) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func addRestaurantPins() {
        for restaurant in mapScreenViewModel.mockRestaurants {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
            annotation.title = restaurant.companyName
            mapView.addAnnotation(annotation)
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
extension MapScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let userAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserLocation")
            userAnnotationView.image = UIImage(systemName: "person.circle.fill")?.withTintColor(.button, renderingMode: .alwaysOriginal)
            userAnnotationView.canShowCallout = true
            return userAnnotationView
        }
        let identifier = "RestaurantPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let rightButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.markerTintColor = .button
        annotationView?.glyphImage = UIImage(systemName: "fork.knife")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        if let title = annotation.title, let subtitle = annotation.subtitle {
            print("Selected restaurant: \(title ?? ""), \(subtitle ?? "")")
        }
    }
}
