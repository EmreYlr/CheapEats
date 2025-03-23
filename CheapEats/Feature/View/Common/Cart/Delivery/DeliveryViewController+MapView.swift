//
//  DeliveryViewController+MapView.swift
//  CheapEats
//
//  Created by Emre on 22.03.2025.
//

import MapKit

extension DeliveryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tintColor = .button
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation.title == "Konumunuz" {
            annotationView?.markerTintColor = .red
            annotationView?.glyphImage = UIImage(systemName: "person.fill")
        } else {
            annotationView?.markerTintColor = .button
            annotationView?.glyphImage = UIImage(systemName: "fork.knife")
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation?.coordinate
        let placemark = MKPlacemark(coordinate: location!)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = view.annotation?.title ?? "Target Location"
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}
