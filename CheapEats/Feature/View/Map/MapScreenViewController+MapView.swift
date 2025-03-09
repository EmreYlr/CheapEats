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
            } else {
                markerView?.annotation = annotation
            }
            markerView?.markerTintColor = .systemRed
            markerView?.glyphImage = UIImage(systemName: "person.fill")
            return markerView
        }
        let identifier = "RestaurantPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tintColor = .button
            rightButton.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
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
        if let title = annotation.title, let productDetail = mapScreenViewModel.productDetail.first(where: { $0.restaurant.companyName == title }) {
            showRestaurantDetails(productDetail)
        }
    }
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode == .none {
            mapView.showsUserLocation = false
        } else {
            mapView.showsUserLocation = true
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotationTitle = view.annotation?.title as? String
        mapScreenViewModel.selectRestaurantByAnnotationTitle(annotationTitle)
        if let annotationCoordinate = view.annotation?.coordinate {
            let region = MKCoordinateRegion(center: annotationCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut], animations: {
                self.mapView.setRegion(region, animated: true)
            }, completion: nil)
        }
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        mapScreenViewModel.selectRestaurant(withId: nil)
    }
    
    private func showRestaurantDetails(_ productDetail: ProductDetails) {
        let detailVC = SB.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.detailViewModel.productDetail = productDetail
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

