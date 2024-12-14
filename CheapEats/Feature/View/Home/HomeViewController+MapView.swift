//
//  HomeViewController+MapView.swift
//  CheapEats
//
//  Created by Emre on 11.12.2024.
//

import Foundation
import MapKit
import CoreLocation

extension HomeViewController: CLLocationManagerDelegate {
    // Kullanıcı izin durumunu değiştirdiğinde tetiklenir
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
            accessView.isHidden = true
        } else if status == .denied {
            print("Kullanıcı konum iznini reddetti.")
            accessView.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Enlem ve boylamı konsola yazdır
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        // Adresi al
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Adres alınamadı: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let address = [
                    placemark.thoroughfare,    // Cadde
                    //placemark.subThoroughfare, // Cadde numarası
                    placemark.locality,        // Şehir
                    placemark.administrativeArea, // İl
                    placemark.postalCode,      // Posta kodu
                    //placemark.country          // Ülke
                ].compactMap { $0 }.joined(separator: ", ")
                self.locationDescriptionLabel.text = address
                print("Adres: \(address)")
            }
        }
    }
    
    // Konum alınamadığında çalışır
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Konum alınamadı: \(error.localizedDescription)")
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
}
