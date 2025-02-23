//
//  UserCreditCard.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

import Foundation
import Firebase

struct UserCreditCards {
    let cardId: String
    let userId: String
    let cardName: String
    let cardNo: String
    let cardMonth: Int
    let cardYear: Int
    let CCV: Int
    let cardType: CardType
    
    init?(dictionary: [String: Any], documentId: String) {
        self.cardId = documentId
        self.userId = dictionary["userId"] as? String ?? ""
        self.cardName = dictionary["cardName"] as? String ?? ""
        self.cardNo = dictionary["cardNo"] as? String ?? ""
        self.cardMonth = dictionary["cardMonth"] as? Int ?? 0
        self.cardYear = dictionary["cardYear"] as? Int ?? 0
        self.CCV = dictionary["CCV"] as? Int ?? 0
        let cardTypeString = dictionary["cardType"] as? String ?? CardType.unknown.rawValue
        self.cardType = CardType(rawValue: cardTypeString) ?? .unknown   
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
