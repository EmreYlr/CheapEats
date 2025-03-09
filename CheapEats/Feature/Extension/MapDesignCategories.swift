//
//  MapDesignCategories.swift
//  CheapEats
//
//  Created by Emre on 9.03.2025.
//

import MapKit

extension MKPointOfInterestCategory {
    static var defaultCategoriesToShow: [MKPointOfInterestCategory] {
        return [
            .park,
            .museum,
            .nationalPark,
            .stadium,
            .university,
            .hospital,
            .hotel,
            .pharmacy,
            .school,
            .gasStation
        ]
    }
}
