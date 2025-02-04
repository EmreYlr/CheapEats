//
//  Restaurant.swift
//  CheapEats
//
//  Created by Emre on 3.02.2025.
//

import Foundation
import FirebaseFirestore

struct Restaurant {
    let restaurantId: String
    let name: String
    let address: String
    let email: String
    let phone: String
    let location: Location
    let createdAt: Date
    
    init?(dictionary: [String: Any], documentId: String) {
        self.restaurantId = documentId
        self.name = dictionary["name"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""

        if let geoPoint = dictionary["location"] as? GeoPoint {
            self.location = Location(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        } else {
            self.location = Location(latitude: 0.0, longitude: 0.0)
        }
        if let timestamp = dictionary["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}

struct Location {
    let latitude: Double
    let longitude: Double
    
    var toGeoPoint: GeoPoint {
        return GeoPoint(latitude: latitude, longitude: longitude)
    }
}
