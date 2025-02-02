//
//  LocationManager.swift
//  CheapEats
//
//  Created by Emre on 1.02.2025.
//

import CoreLocation

final class LocationManager {
    static let shared = LocationManager()
    
    private init() {}
    
    var currentLatitude: Double?
    var currentLongitude: Double?
}
