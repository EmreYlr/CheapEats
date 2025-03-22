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
            startLocationServices()
            accessView.isHidden = true
        } else if status == .denied {
            print("Kullanıcı konum iznini reddetti.")
            accessView.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        LocationManager.shared.currentLatitude = latitude
        LocationManager.shared.currentLongitude = longitude
        LocationManager.shared.currentLocation = location.coordinate
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
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
                LocationManager.shared.currentAddress = address
                print("Adres: \(address)")
                self.stopLocationServices()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Konum alınamadı: \(error.localizedDescription)")
        stopLocationServices()
    }
    
    func startLocationServices() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationServices() {
        locationManager.stopUpdatingLocation()
    }
}
