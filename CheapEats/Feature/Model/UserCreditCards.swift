//
//  UserCreditCard.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

import Foundation
import Firebase

struct UserCreditCards {
    var cardId: String
    let userId: String
    let cardName: String
    let cardOwnerName: String
    let cardNo: String
    let cardMonth: Int
    let cardYear: Int
    let CVV: Int
    let cardType: CardType
    let createdAt: Date
    
    init?(dictionary: [String: Any], documentId: String) {
        self.cardId = documentId
        self.userId = dictionary["userId"] as? String ?? ""
        self.cardName = dictionary["cardName"] as? String ?? ""
        self.cardOwnerName = dictionary["cardOwnerName"] as? String ?? ""
        self.cardNo = dictionary["cardNo"] as? String ?? ""
        self.cardMonth = dictionary["cardMonth"] as? Int ?? 0
        self.cardYear = dictionary["cardYear"] as? Int ?? 0
        self.CVV = dictionary["CVV"] as? Int ?? 0
        let cardTypeString = dictionary["cardType"] as? String ?? CardType.unknown.rawValue
        self.cardType = CardType(rawValue: cardTypeString) ?? .unknown
        if let timestamp = dictionary["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
    
    init(userId: String, cardName: String, cardOwnerName: String, cardNo: String,
         cardMonth: Int, cardYear: Int, CVV: Int, cardType: CardType) {
        self.cardId = ""
        self.userId = userId
        self.cardName = cardName
        self.cardOwnerName = cardOwnerName
        self.cardNo = cardNo
        self.cardMonth = cardMonth
        self.cardYear = cardYear
        self.CVV = CVV
        self.cardType = cardType
        self.createdAt = Date()
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "cardId": cardId,
            "userId": userId,
            "cardName": cardName,
            "cardOwnerName": cardOwnerName,
            "cardNo": cardNo,
            "cardMonth": cardMonth,
            "cardYear": cardYear,
            "CVV": CVV,
            "cardType": cardType.rawValue,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}

enum CardType: String, CaseIterable, CustomStringConvertible {
    case mastercard = "Mastercard"
    case visa = "Visa"
    case troy = "Troy"
    case unknown = "Unknown"
    
    var description: String {
        return self.rawValue
    }
}
