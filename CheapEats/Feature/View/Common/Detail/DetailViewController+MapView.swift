//
//  DetailViewController+MapView.swift
//  CheapEats
//
//  Created by Emre on 5.02.2025.
//

import MapKit

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "RestaurantPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(systemName: "fork.knife.circle")
        annotationView?.tintColor = .button
        annotationView?.frame.size = CGSize(width: 25, height: 25)
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
