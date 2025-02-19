//
//  UserOrders.swift
//  CheapEats
//
//  Created by Emre on 19.02.2025.
//

import Foundation
import Firebase

struct UserOrder {
    var orderId: String
    var orderDate: Date
    var orderNo: String
    var productId: String
    var restaurantId: String
    var status: OrderStatus
    var userId: String
    
    init?(dictionary: [String: Any], documentId: String) {
        self.orderId = documentId
        if let timestamp = dictionary["orderDate"] as? Timestamp {
            self.orderDate = timestamp.dateValue()
        } else {
            self.orderDate = Date()
        }
        self.orderNo = dictionary["orderNo"] as? String ?? ""
        self.productId = dictionary["productId"] as? String ?? ""
        self.restaurantId = dictionary["restaurantId"] as? String ?? ""
        let statusString = dictionary["status"] as? String ?? OrderStatus.delivered.rawValue
        self.status = OrderStatus(rawValue: statusString) ?? .preparing
        self.userId = dictionary["userId"] as? String ?? ""
        }
}

enum OrderStatus: String, CaseIterable, CustomStringConvertible {
    case preparing = "Hazırlanıyor"
    case delivered = "Teslim Edildi"
    case canceled = "İptal Edildi"
    
    var description: String {
        return self.rawValue
    }
}
