//
//  Product.swift
//  CheapEats
//
//  Created by Emre on 10.12.2024.
//

import Foundation

struct Product {
    let company: String
    let food: String
    let date: String
    let oldAmount: String
    let newAmount: String
    let imageUrl: String
    let mealType: [MealType]
}

enum MealType: String, CaseIterable, CustomStringConvertible {
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

