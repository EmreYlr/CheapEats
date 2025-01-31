//
//  Product.swift
//  CheapEats
//
//  Created by Emre on 10.12.2024.
//

import Foundation

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

/*
 import FirebaseFirestore

 fetchProducts { products, error in
     if let error = error {
         print("Error fetching products: \(error)")
     } else if let products = products {
         for product in products {
             print("Product Name: \(product.name), Price: \(product.price)")
         }
     }
 }
 */

