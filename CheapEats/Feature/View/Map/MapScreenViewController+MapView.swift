//
//  MapScreenViewController+MapView.swift
//  CheapEats
//
//  Created by Emre on 3.03.2025.
//

import MapKit

extension MapScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation === mapScreenViewModel.userAnnotation {
            let identifier = "UserLocationMarker"
            var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if markerView == nil {
                markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                markerView?.canShowCallout = true
                markerView?.markerTintColor = .systemRed
                markerView?.glyphImage = UIImage(systemName: "person.fill")
            } else {
                markerView?.annotation = annotation
            }
            return markerView
        }
        let identifier = "RestaurantPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .button
            annotationView?.glyphImage = UIImage(systemName: "fork.knife")
            let rightButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        if let title = annotation.title,
           let restaurant = mapScreenViewModel.mockRestaurants.first(where: { $0.companyName == title }) {
               print(restaurant)
            //showRestaurantDetails(restaurant)
        }
    }
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode == .none {
            mapView.showsUserLocation = false
        } else {
            mapView.showsUserLocation = true
        }
    }
}

