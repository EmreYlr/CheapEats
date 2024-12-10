//
//  OrderDetail.swift
//  CheapEats
//
//  Created by CANSU on 1.12.2024.
//

import Foundation
import Foundation

struct OrderDetail {
    let company: String
    let food: String
    let date: String
    let orderNumber: String
    let oldHolds: String
    let discount: String
    let newAmount: String
    let total: String
    let imageUrl: String

    init?(dictionary: [String: Any]) {
        guard
            let company = dictionary["company"] as? String,
            let food = dictionary["food"] as? String,
            let date = dictionary["date"] as? String,
            let orderNumber = dictionary["orderNumber"] as? String,
            let oldHolds = dictionary["oldHolds"] as? String,
            let discount = dictionary["discount"] as? String,
            let newAmount = dictionary["newAmount"] as? String,
            let total = dictionary["total"] as? String,
            let imageUrl = dictionary["imageUrl"] as? String
        else {
            return nil
        }
        
        self.company = company
        self.food = food
        self.date = date
        self.orderNumber = orderNumber
        self.oldHolds = oldHolds
        self.discount = discount
        self.newAmount = newAmount
        self.total = total
        self.imageUrl = imageUrl
    }
}

