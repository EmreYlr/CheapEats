//
//  Orders.swift
//  CheapEats
//
//  Created by Emre on 14.12.2024.
//

import Foundation

struct Orders {
    let orderNumber: String
    let company: String
    let food: String
    let date: String
    let imageUrl: String
    let oldAmount: String
    let newAmount: String
    let orderStatus: OrderStatus
}

enum OrderStatus: String, CaseIterable, CustomStringConvertible {
    case preparing = "Hazırlanıyor"
    case delivered = "Teslim Edildi"
    case canceled = "İptal Edildi"
    
    var description: String {
        return self.rawValue
    }
}
