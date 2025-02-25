//
//  AddCardViewController+TextField.swift
//  CheapEats
//
//  Created by Emre on 23.02.2025.
//
import UIKit

extension AddCardViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case cardNoTextField:
            handleCardNumberChange(textField)
        case monthTextField:
            handleMonthChange(textField)
        case yearTextField:
            handleYearChange(textField)
        case cardOwnerNameTextField:
            handleCardOwnerNameChange(textField)
        case CVVTextField:
            handleCVVChange(textField)
        default:
            break
        }
    }
    
    private func handleCardNumberChange(_ textField: UITextField) {
        guard let text = textField.text?.replacingOccurrences(of: " ", with: "") else { return }
        if text.count == 16 {
            monthTextField.becomeFirstResponder()
        }
        
        let placeholder = "XXXX XXXX XXXX XXXX"
        
        let numbers = (textField.text ?? "").filter { $0.isNumber }
        let truncated = String(numbers.prefix(16))
        textField.text = truncated
        
        var formatted = ""
        for (index, char) in truncated.enumerated() {
            formatted += String(char)
            if (index + 1) % 4 == 0 && index != truncated.count - 1 {
                formatted += " "
            }
        }
        
        let displayText = NSMutableAttributedString(string: placeholder)
        displayText.addAttribute(.foregroundColor,
                                 value: UIColor.gray,
                                 range: NSRange(location: 0, length: placeholder.count))
        
        if !formatted.isEmpty {
            displayText.addAttribute(.foregroundColor,
                                     value: UIColor.white,
                                     range: NSRange(location: 0, length: formatted.count))
            
            for (index, char) in formatted.enumerated() {
                displayText.replaceCharacters(in: NSRange(location: index, length: 1), with: String(char))
            }
        }
        
        let cardType = determineCardType(cardNumber: text)
        updateCardTypeImage(cardType: cardType)
        
        cardNoTextLabel.attributedText = displayText
    }
    
    private func handleMonthChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count == 2 {
            if let month = Int(text) {
                if month > 12 {
                    textField.text = "12"
                } else if month == 0 {
                    textField.text = "01"
                }
                yearTextField.becomeFirstResponder()
            }
        }
        updateExpiryDateLabel()
    }
    
    private func handleYearChange(_ textField: UITextField) {
        guard let text = textField.text, let year = Int(text) else { return }
        if text.isEmpty {
            updateExpiryDateLabel()
            return
        }
        let currentYear = getCurrentYear()
        let maxYear = currentYear + 20
        
        if text.count == 2 {
            if year < currentYear {
                textField.text = String(format: "%02d", currentYear)
            } else if year > maxYear {
                textField.text = String(format: "%02d", maxYear)
            }
            CVVTextField.becomeFirstResponder()
        }
        updateExpiryDateLabel()
    }
    
    private func handleCardOwnerNameChange(_ textField: UITextField) {
        let upperCasedText = textField.text?.uppercased() ?? ""
        textField.text = upperCasedText
        if upperCasedText.isEmpty {
            cardNameTextLabel.text = "Kart Üzerindeki İsim"
            cardNameTextLabel.textColor = .gray
        } else {
            cardNameTextLabel.text = upperCasedText
            cardNameTextLabel.textColor = .white
        }
    }
    
    private func handleCVVChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            CVVTextLabel.text = text
            CVVTextLabel.textColor = .white
        } else {
            CVVTextLabel.text = "CVV"
            CVVTextLabel.textColor = .gray
        }
    }
    
    private func updateExpiryDateLabel() {
        let month = monthTextField.text ?? ""
        let year = yearTextField.text ?? ""
        
        if month.isEmpty && year.isEmpty {
            expiryDateTextLabel.text = "AA/YY"
            expiryDateTextLabel.textColor = .gray
        } else {
            let displayMonth = month.isEmpty ? "AA" : month
            let displayYear = year.isEmpty ? "YY" : year
            expiryDateTextLabel.text = "\(displayMonth)/\(displayYear)"
            expiryDateTextLabel.textColor = .white
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == CVVTextField && !isOpen {
            self.cardViewTapped()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == CVVTextField && isOpen {
            self.cardViewTapped()
        }
        if textField == monthTextField {
            if let text = textField.text, let month = Int(text), text.count == 1 {
                textField.text = String(format: "%02d", month)
            }
        }
        else if textField == yearTextField {
            if let text = textField.text, text.count == 1 {
                textField.text = "0" + text
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        switch textField {
        case cardNoTextField:
            let numbersOnly = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isNumber = numbersOnly.isSuperset(of: characterSet)
            return isNumber && updatedText.count <= 16
            
        case monthTextField:
            let isNumber = string.isEmpty || string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            return isNumber && updatedText.count <= 2
            
        case yearTextField:
            let isNumber = string.isEmpty || string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            if string.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                                    self?.updateExpiryDateLabel()
                                }
            }
            return isNumber && updatedText.count <= 2
            
        case CVVTextField:
            let isNumber = string.isEmpty || string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            return isNumber && updatedText.count <= 3
            
        case cardOwnerNameTextField:
            let allowedCharacters = CharacterSet.letters.union(CharacterSet.whitespaces)
            let characterSet = CharacterSet(charactersIn: string)
            return string.isEmpty || allowedCharacters.isSuperset(of: characterSet)
            
        default:
            return true
        }
    }
    
    private func updateCardTypeImage(cardType: CardType) {
        switch cardType {
        case .visa:
            cardTypeImage.image = UIImage(named: "VisaLogo")
            cardTypeImage.isHidden = isOpen
        case .mastercard:
            cardTypeImage.image = UIImage(named: "MCLogo")
            cardTypeImage.isHidden = isOpen
        case .troy:
            cardTypeImage.image = UIImage(named: "troyLogo")
            cardTypeImage.isHidden = isOpen
        case .unknown:
            cardTypeImage.image = nil
            cardTypeImage.isHidden = true
        }
    }
    
    private func getCurrentYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        return Int(dateFormatter.string(from: Date())) ?? 0
    }
}
