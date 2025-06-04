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
    var status: OrderStatus
    var userId: String
    var cardInfo: String
    var selectedDeliveryType: DeliveryType
    var couponId: String
    var quantity: Int
    
    init?(dictionary: [String: Any], documentId: String) {
        self.orderId = documentId
        if let timestamp = dictionary["orderDate"] as? Timestamp {
            self.orderDate = timestamp.dateValue()
        } else {
            self.orderDate = Date()
        }
        self.orderNo = dictionary["orderNo"] as? String ?? ""
        self.cardInfo = dictionary["cardInfo"] as? String ?? ""
        self.productId = dictionary["productId"] as? String ?? ""
        let statusString = dictionary["status"] as? String ?? OrderStatus.delivered.rawValue
        self.status = OrderStatus(rawValue: statusString) ?? .preparing
        self.userId = dictionary["userId"] as? String ?? ""
        let selectedDeliveryTypeString = dictionary["selectedDeliveryType"] as? String ?? DeliveryType.delivery.rawValue
        self.selectedDeliveryType = DeliveryType(rawValue: selectedDeliveryTypeString) ?? .delivery
        self.couponId = dictionary["couponId"] as? String ?? ""
        self.quantity = dictionary["quantity"] as? Int ?? 1
    }
    
    init(productId: String, userId: String, selectedDeliveryType: DeliveryType) {
        self.orderId = ""
        self.orderDate = Date()
        self.orderNo = ""
        self.productId = productId
        self.status = .preparing
        self.userId = userId
        self.cardInfo = ""
        self.selectedDeliveryType = selectedDeliveryType
        self.couponId = ""
        self.quantity = 0
    }
    
    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "orderDate": Timestamp(date: self.orderDate),
            "orderNo": self.orderNo,
            "productId": self.productId,
            "status": self.status.rawValue,
            "userId": self.userId,
            "cardInfo": self.cardInfo,
            "selectedDeliveryType": self.selectedDeliveryType.rawValue,
            "couponId": couponId,
            "quantity": self.quantity,
        ]

        return dict
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
