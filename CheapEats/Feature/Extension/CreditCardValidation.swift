//
//  CreditCardValidation.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//

protocol CreditCardSettings {
    func isValidCardNumber(_ cardNumber: String) -> Bool
    func determineCardType(cardNumber: String) -> CardType
}

extension CreditCardSettings {
    func isValidCardNumber(_ cardNumber: String) -> Bool {
        let trimmedCardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        guard trimmedCardNumber.allSatisfy({ $0.isNumber }) else {
            return false
        }
        
        var sum = 0
        let reversedDigits = trimmedCardNumber.reversed().map { Int(String($0))! }
        for (index, digit) in reversedDigits.enumerated() {
            if index % 2 == 1 {
                let doubledDigit = digit * 2
                sum += doubledDigit > 9 ? doubledDigit - 9 : doubledDigit
            } else {
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
    
    func determineCardType(cardNumber: String) -> CardType {
        guard cardNumber.count >= 4 else {
            return .unknown
        }
        
        let prefix1 = String(cardNumber.prefix(1))
        let prefix2 = String(cardNumber.prefix(2))
        let prefix4 = String(cardNumber.prefix(4))
        let prefix6 = String(cardNumber.prefix(6))
        
        if prefix1 == "4" {
            return .visa
        } else if let prefixInt = Int(prefix2), (51...55).contains(prefixInt) {
            return .mastercard
        } else if let prefixInt = Int(prefix6), (2221...2720).contains(prefixInt) {
            return .mastercard
        } else if prefix4 == "9792" {
            return .troy
        } else {
            return .unknown
        }
    }
}

extension AddCardViewController: CreditCardSettings {}
extension PaymentViewController: CreditCardSettings {}
