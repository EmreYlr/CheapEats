//
//  Product.swift
//  CheapEats
//
//  Created by Emre on 10.12.2024.
//

import Foundation
import Firebase

struct Product {
    var productId: String
    var name: String
    var description: String
    var oldPrice: String
    var newPrice: String
    var restaurantId: String
    var restaurantName: String
    var category: [Category]
    var imageUrl: String
    var deliveryType: DeliveryType
    var createdAt: Date
    var endDate: String
    
    init?(dictionary: [String: Any], documentId: String) {
            self.productId = documentId
            self.name = dictionary["name"] as? String ?? ""
            self.description = dictionary["description"] as? String ?? ""
            self.oldPrice = dictionary["oldPrice"] as? String ?? ""
            self.newPrice = dictionary["newPrice"] as? String ?? ""
            self.restaurantId = dictionary["restaurantId"] as? String ?? ""
            self.restaurantName = dictionary["restaurantName"] as? String ?? ""
            let categoryStrings = dictionary["category"] as? [String] ?? []
            self.category = categoryStrings.compactMap { Category(rawValue: $0) }
            self.imageUrl = dictionary["imageUrl"] as? String ?? ""
            let deliveryTypeString = dictionary["deliveryType"] as? String ?? DeliveryType.all.rawValue
            self.deliveryType = DeliveryType(rawValue: deliveryTypeString) ?? .all
            if let timestamp = dictionary["createdAt"] as? Timestamp {
                self.createdAt = timestamp.dateValue()
            } else {
                self.createdAt = Date()
            }
            self.endDate = dictionary["endDate"] as? String ?? "00:00"
        }
}

enum Category: String, CaseIterable, CustomStringConvertible {
    case burger = "Burger"
    case doner = "Döner"
    case tatlı = "Tatlı"
    case pizza = "Pizza"
    case tavuk = "Tavuk"
    case kofte = "Köfte"
    case evYemek = "Ev Yemekleri"
    case pastane = "Pastane & Fırın"
    case kebap = "Kebap"
    case kahvaltı = "Kahvaltı"
    case vegan = "Vegan"
    case corba = "Çorba"
    
    var description: String {
        return self.rawValue
    }
}

enum DeliveryType: String {
    case all = "Hepsi"
    case delivery = "Gel-Al"
    case takeout = "Kurye"
    
    var description: String {
        return self.rawValue
    }
}
